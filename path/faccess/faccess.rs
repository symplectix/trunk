//! Checks accessibility of a file.

use bitflags::bitflags;
use std::ffi::OsStr;
use std::io;

bitflags! {
    pub struct Mode: libc::c_int {
        const EXISTS  = libc::F_OK;
        const EXECUTE = libc::X_OK;
        const WRITE   = libc::W_OK;
        const READ    = libc::R_OK;
    }
}

#[cfg(unix)]
pub fn check<P: AsRef<OsStr>>(path: P, mode: Mode) -> io::Result<()> {
    use libc::faccessat;
    use std::ffi::CString;
    use std::os::unix::ffi::OsStrExt;

    // Perform access checks using the effective user and group IDs.
    // By default, faccessat() uses the real IDs.
    #[cfg(not(target_os = "android"))]
    use libc::AT_EACCESS;

    // Android does not support AT_EACCESS.
    // https://android.googlesource.com/platform/bionic/+/master/libc/bionic/faccessat.cpp#45
    #[cfg(target_os = "android")]
    const AT_EACCESS: libc::c_int = 0;

    let cstr = CString::new(path.as_ref().as_bytes())?;
    let path = cstr.as_ptr() as *const libc::c_char;

    if unsafe { faccessat(libc::AT_FDCWD, path, mode.bits(), AT_EACCESS) } == 0 {
        Ok(())
    } else {
        Err(io::Error::last_os_error())
    }
}

#[cfg(test)]
mod test {
    use super::*;
    use testing::rlocation;

    #[test]
    fn faccessat_runfiles() {
        assert!(check(rlocation(".rustfmt.toml"), Mode::EXISTS).is_ok());
        assert!(check(rlocation(".clippy.toml"), Mode::EXISTS).is_ok());
        assert!(check(rlocation("path/faccess/faccess.rs"), Mode::EXISTS).is_ok());

        assert!(check(rlocation(".rustfmt.toml"), Mode::READ).is_ok());
        assert!(check(rlocation(".clippy.toml"), Mode::READ).is_ok());
        assert!(check(rlocation("path/faccess/faccess.rs"), Mode::READ).is_ok());

        assert!(check(rlocation(".rustfmt.toml"), Mode::WRITE).is_err());
        assert!(check(rlocation(".clippy.toml"), Mode::WRITE).is_err());
        assert!(check(rlocation("path/faccess/faccess.rs"), Mode::WRITE).is_err());

        assert!(check(rlocation(".rustfmt.toml"), Mode::EXECUTE).is_err());
        assert!(check(rlocation(".clippy.toml"), Mode::EXECUTE).is_err());
        assert!(check(rlocation("path/faccess/faccess.rs"), Mode::EXECUTE).is_err());
    }
}
