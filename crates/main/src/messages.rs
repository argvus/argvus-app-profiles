//! The messages of the launcher, from argvus-i18n (domain `app-profiles`).
//! Without the translator the key itself is printed, as the script did.

use std::env;
use std::io::Write;
use std::path::PathBuf;
use std::process::{Command, Stdio};

/// Prints a message of the `app-profiles` domain on standard error.
pub fn error(key: &str, arguments: &[String]) {
  let bytes = translate(key, arguments).unwrap_or_else(|| format!("{key}\n").into_bytes());
  let _ = std::io::stderr().write_all(&bytes);
}

fn translate(key: &str, arguments: &[String]) -> Option<Vec<u8>> {
  let commands = env::var_os("ARGVUS_COMMANDS_DIR")
    .filter(|value| !value.is_empty())
    .map(PathBuf::from)
    .unwrap_or_else(|| PathBuf::from("/usr/lib/argvus/commands"));
  let translator = commands.join("argvus-i18n");
  if !translator.is_file() {
    return None;
  }
  let output = Command::new(translator)
    .args(["get", "app-profiles", key])
    .args(arguments)
    .stderr(Stdio::inherit())
    .output()
    .ok()?;
  Some(output.stdout)
}
