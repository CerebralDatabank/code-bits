const fs = require("fs");

const FILE_IN = "accounts.csv";
const FILE_OUT = "otp-uris.txt";

/* CSV headers:
 * _id,group_key,name,username,paws_url,oath_secret_key,oath_enabled,cid,cached_pin,ngc_ski,aad_user_id,aad_tenant_id,account_type,account_capability,ux_position,is_totp_code_shown,encrypted_oath_secret_key,mfa_pin_encryption_key_alias,identity_provider,is_third_party_account_logo_domain_based,msa_token_version_flag,aad_ngc_totp_enabled,aad_authority,restore_capability,has_password,aad_security_defaults_policy_enabled,phone_app_detail_id,replication_scope,activated_device_token,routing_hint,tenant_country_code,data_boundary,puid,is_passkey_deleted_for_wrong_approval_pin
 */

function processField(value) {
  const str = value.replace(/^"(.*)"$/, "$1");
  return encodeURIComponent(str);
}

fs.readFile(FILE_IN, "utf8", (err, data) => {
  if (err) {
    console.error(err);
    return;
  }
  const lines = data.split("\n").filter(line => line.trim() !== "");
  const header = lines[0].split(/,(?=(?:(?:[^"]*"){2})*[^"]*$)/);
  const nameIdx = header.indexOf("name");
  const usernameIdx = header.indexOf("username");
  const oathSecretKeyIdx = header.indexOf("oath_secret_key");

  const outputLines = [];

  for (let i = 1; i < lines.length; i++) {
    const cols = lines[i].split(/,(?=(?:(?:[^"]*"){2})*[^"]*$)/);

    const rawName = cols[nameIdx].replace(/^"(.*)"$/, "$1");
    const rawUsername = cols[usernameIdx].replace(/^"(.*)"$/, "$1");

    const name = processField(cols[nameIdx]);
    const username = processField(cols[usernameIdx]);
    const oathSecretKey = processField(cols[oathSecretKeyIdx]);

    const uri = `otpauth://totp/${name}:${username}?secret=${oathSecretKey}`;
    outputLines.push(uri);
    console.log(`${rawName} (${rawUsername})`);
  }

  fs.writeFile(FILE_OUT, outputLines.join("\n"), "utf8", err => {
    if (err) {
      console.error(err);
      return;
    }
    console.log(`Converted ${outputLines.length} entries; saved as otp-uris.txt.`);
  });
});
