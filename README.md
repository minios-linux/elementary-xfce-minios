# elementary-xfce-minios

## Project Description
`elementary-xfce-minios` is an icon theme designed for use in MiniOS. It is based on [elementary-xfce](https://github.com/shimmerproject/elementary-xfce).

## Dependencies
The following tools are required to build the project:
- `git`
- `rsync`
- `make`

Ensure these tools are installed on your system before starting the build process.

## Build Instructions
1. Clone the repository (if not already done):
   ```bash
   git clone <repository URL>
   cd elementary-xfce-minios
   ```
2. Verify that all dependencies are installed:
   ```bash
   make check-deps
   ```
3. Build the project:
   ```bash
   make build
   ```
   All build artifacts will be located in the `build/` directory.

## Makefile Usage Examples
- **Build the project:**
  ```bash
  make build
  ```
- **Clean temporary files:**
  ```bash
  make clean-temp
  ```
- **Perform a full cleanup of build artifacts:**
  ```bash
  make clean
  ```
- **View available Makefile targets:**
  ```bash
  make help
  ```

## Additional Information
For more information about the project, refer to the documentation or the `Makefile`.
