function resourceName() {
  try {
    return typeof GetParentResourceName === "function"
      ? GetParentResourceName()
      : "sharky_bank";
  } catch {
    return "sharky_bank";
  }
}

/** @param {string} name @param {Record<string, unknown>} [body] */
export async function postNui(name, body = {}) {
  const res = await fetch(`https://${resourceName()}/${name}`, {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=UTF-8" },
    body: JSON.stringify(body),
  });
  if (!res.ok) throw new Error("NUI request failed");
  return res;
}
