import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

try {
  await prisma.user.upsert({
    where: { id: "11111111-1111-4111-8111-111111111111" },
    update: {},
    create: { id: "11111111-1111-4111-8111-111111111111" },
  });
  console.log("Usuario de prueba disponible: 11111111-1111-4111-8111-111111111111");
} finally {
  await prisma.$disconnect();
}