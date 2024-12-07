fn main() -> windows_registry::Result<()> {
    let windows_edition = windows_registry::LOCAL_MACHINE
        .open(r"SOFTWARE\Microsoft\Windows NT\CurrentVersion")?
        .get_string("EditionID")
        .ok();

    println!(
        "Hello World, from a machine running Windows {}.",
        windows_edition.as_deref().unwrap_or("<unknown>")
    );

    Ok(())
}
