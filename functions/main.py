"""Cloud Functions for the experience_app.

Sends a push notification to the buyer when a new order is created.
Trigger: Firestore document created at orders/{orderId}.
"""

from firebase_admin import initialize_app, firestore, messaging
from firebase_functions import firestore_fn

initialize_app()


@firestore_fn.on_document_created(document="orders/{orderId}")
def notify_order_created(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
    """When an order is created, notify the buyer on all their devices."""
    snapshot = event.data
    if snapshot is None:
        return

    order = snapshot.to_dict() or {}
    order_id = event.params["orderId"]

    user_id = order.get("userId")
    if not user_id:
        print(f"Order {order_id} has no userId; skipping notification.")
        return

    total = order.get("total", 0)
    currency = order.get("currency", "USD")

    # Look up the buyer's registered device tokens.
    db = firestore.client()
    user_doc = db.collection("users").document(user_id).get()
    if not user_doc.exists:
        print(f"User {user_id} not found; skipping.")
        return

    tokens = (user_doc.to_dict() or {}).get("fcmTokens", [])
    if not tokens:
        print(f"User {user_id} has no fcmTokens; skipping.")
        return

    title = "Compra exitosa"
    body = f"Tu compra por {currency} ${total:.2f} fue procesada."

    # Send to each token. `data` carries the orderId so the app can open the
    # order detail when the notification is tapped.
    message = messaging.MulticastMessage(
        tokens=tokens,
        notification=messaging.Notification(title=title, body=body),
        data={"orderId": order_id},
        android=messaging.AndroidConfig(
            priority="high",
            notification=messaging.AndroidNotification(
                channel_id="orders_channel",
            ),
        ),
    )

    response = messaging.send_each_for_multicast(message)
    print(f"Order {order_id}: sent {response.success_count}, "
          f"failed {response.failure_count}.")

    # Clean up tokens that are no longer valid.
    if response.failure_count > 0:
        invalid = []
        for idx, resp in enumerate(response.responses):
            if not resp.success:
                invalid.append(tokens[idx])
        if invalid:
            db.collection("users").document(user_id).update({
                "fcmTokens": firestore.ArrayRemove(invalid),
            })
