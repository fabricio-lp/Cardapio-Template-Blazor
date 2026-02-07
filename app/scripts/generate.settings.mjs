import fs from "fs";

const templatePath = "app/wwwroot/settings.template.json";
const outPath = "app/wwwroot/settings.json";

const template = fs.readFileSync(templatePath, "utf8");

const env = (k, fallback = "") => (process.env[k] ?? fallback);

const map = {
  WHATSAPP_NUMBER: env("WHATSAPP_NUMBER", ""),
  TAXA: env("TAXA", "0"),
  MENU_CSV_URL: env("MENU_CSV_URL", ""),
  INSTAGRAM_URL: env("INSTAGRAM_URL", ""),
  MAPS_URL: env("MAPS_URL", ""),
  ENDERECO: env("ENDERECO", "")
};

const esc = (v) => String(v).replaceAll("\\", "\\\\").replaceAll('"', '\\"');

let out = template;
for (const [k, v] of Object.entries(map)) {
  out = out.replaceAll(`\${${k}}`, esc(v));
}

fs.writeFileSync(outPath, out, "utf8");
console.log("settings.json gerado:", outPath);
