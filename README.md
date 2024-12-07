Rust projects on Windows link to kernel32.dll, advapi32.dll, etc, through the standard library or 
other third-party libraries like windows-rs.

There is sometimes the specialized need to customize linking, for example by binding directly to
[APISet](https://learn.microsoft.com/en-us/windows/win32/apiindex/windows-apisets) -
contract names, or to provide substitute DLLs depending on the target OS combinations.
An example where contract names might be useful would be to avoid certain DLLs that are part of the
dependency graph of the historic, well-known names. This might be useful if you wish to run your
code under the [win32k process mitigation](https://github.com/microsoft/SandboxSecurityTools),
which fails user32's DLL load. user32.dll is a dependency of ole32.dll,  which means COM is not
available *unless* you link the the APISet contracts, which avoid this dependency.

Which libraries are sent to the linker is not currently a customizable extension point in Cargo.
This repository demonstrates a workaround. The linker to use *is* customizable, so this project
creates a batch script (apisetlinker.cmd) which intercepts invocations of the MSVC linker and 
removes problematic library references and allows you to replace them with your own.
apisetlinker.cmd is configured in .config/cargo.toml.


