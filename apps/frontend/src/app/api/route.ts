import { prisma } from "@repo/database";

export async function GET() {

  const users = await prisma.user.findMany()

  return Response.json(JSON.stringify({
    message: "Success",
    data: users
  }), { status: 200 })
}