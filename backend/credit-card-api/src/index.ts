import { Prisma, PrismaClient, CardStatus } from "@prisma/client";
import express, { type ErrorRequestHandler, type NextFunction, type Request, type RequestHandler, type Response } from "express";
import { z } from "zod";

const prisma = new PrismaClient();
const app = express();
const port = Number(process.env.PORT ?? 3000);
const basePath = "/api/v1/credit-cards";

app.use(express.json());

const idSchema = z.string().uuid();
const createCardSchema = z.object({
  userId: z.string().uuid(),
  creditLimit: z.number().finite().positive(),
}).strict();
const updateCardSchema = z.object({
  creditLimit: z.number().finite().positive().optional(),
  status: z.nativeEnum(CardStatus).optional(),
}).strict().refine((body) => Object.keys(body).length > 0, {
  message: "Debe enviar creditLimit o status.",
});

type AsyncHandler = (request: Request, response: Response, next: NextFunction) => Promise<void>;

const asyncHandler = (handler: AsyncHandler): RequestHandler => (request, response, next) => {
  void handler(request, response, next).catch(next);
};

app.get(basePath, asyncHandler(async (_request, response) => {
  const cards = await prisma.creditCard.findMany({
    where: { status: CardStatus.ACTIVE, deletedAt: null },
    orderBy: { createdAt: "desc" },
  });
  response.status(200).json(cards);
}));

app.post(basePath, asyncHandler(async (request, response) => {
  const input = createCardSchema.safeParse(request.body);
  if (!input.success) {
    response.status(400).json({ error: "Datos inválidos.", details: input.error.flatten() });
    return;
  }

  const userExists = await prisma.user.findUnique({ where: { id: input.data.userId } });
  if (!userExists) {
    response.status(400).json({ error: "El userId no corresponde a un usuario existente." });
    return;
  }

  const card = await prisma.creditCard.create({ data: input.data });
  response.status(201).json(card);
}));

app.get(`${basePath}/:id`, asyncHandler(async (request, response) => {
  const id = idSchema.safeParse(request.params.id);
  if (!id.success) {
    response.status(400).json({ error: "El id debe ser un UUID válido." });
    return;
  }

  const card = await prisma.creditCard.findFirst({
    where: { id: id.data, deletedAt: null },
  });
  if (!card) {
    response.status(404).json({ error: "Tarjeta no encontrada." });
    return;
  }
  response.status(200).json(card);
}));

app.patch(`${basePath}/:id`, asyncHandler(async (request, response) => {
  const id = idSchema.safeParse(request.params.id);
  if (!id.success) {
    response.status(400).json({ error: "El id debe ser un UUID válido." });
    return;
  }

  const input = updateCardSchema.safeParse(request.body);
  if (!input.success) {
    response.status(400).json({ error: "Datos inválidos.", details: input.error.flatten() });
    return;
  }

  const existingCard = await prisma.creditCard.findFirst({
    where: { id: id.data, deletedAt: null },
    select: { id: true },
  });
  if (!existingCard) {
    response.status(404).json({ error: "Tarjeta no encontrada." });
    return;
  }

  const card = await prisma.creditCard.update({
    where: { id: existingCard.id },
    data: input.data,
  });
  response.status(200).json(card);
}));

app.delete(`${basePath}/:id`, asyncHandler(async (request, response) => {
  const id = idSchema.safeParse(request.params.id);
  if (!id.success) {
    response.status(400).json({ error: "El id debe ser un UUID válido." });
    return;
  }

  const result = await prisma.creditCard.updateMany({
    where: { id: id.data, deletedAt: null },
    data: { deletedAt: new Date() },
  });
  if (result.count === 0) {
    response.status(404).json({ error: "Tarjeta no encontrada." });
    return;
  }
  response.status(204).send();
}));

app.use(((error: unknown, _request, response, _next) => {
  if (error instanceof Prisma.PrismaClientKnownRequestError && error.code === "P2003") {
    response.status(400).json({ error: "El userId no corresponde a un usuario existente." });
    return;
  }
  console.error(error);
  response.status(500).json({ error: "Error interno del servidor." });
}) satisfies ErrorRequestHandler);

app.listen(port, () => {
  console.log(`API de tarjetas disponible en http://localhost:${port}`);
});

process.on("beforeExit", async () => {
  await prisma.$disconnect();
});