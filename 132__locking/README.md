# terraform-aws-force-unlock

A utility module for forcibly unlocking Terraform state files in AWS environments.

## Overview

When a Terraform state file becomes locked (for example, due to an interrupted operation), you may need to manually unlock it to resume your workflow. This module provides a safe and automated way to force-unlock Terraform state files stored in AWS backends.

## Features

- Automates the process of running `terraform force-unlock`
- Supports AWS S3 backends
- Helps prevent manual errors when unlocking state files
- Can be integrated into CI/CD pipelines

## Usage

1. **Clone this repository:**
    ```sh
    git clone https://github.com/your-org/terraform-aws-force-unlock.git
    cd terraform-aws-force-unlock
    ```

2. **Set the required variables:**
    - `LOCK_ID`: The lock ID to unlock (you can find this in the error message or the DynamoDB table if using state locking).
    - `AWS_PROFILE` (optional): The AWS CLI profile to use.

3. **Run the unlock script:**
    ```sh
    ./force-unlock.sh <LOCK_ID> [AWS_PROFILE]
    ```

    Example:
    ```sh
    ./force-unlock.sh 12345678-aaaa-bbbb-cccc-ddddeeeeffff my-aws-profile
    ```

## Prerequisites

- [Terraform CLI](https://www.terraform.io/downloads.html) installed
- AWS CLI configured with appropriate permissions
- Access to the S3 bucket and DynamoDB table (if used for state locking)

## Notes

- Use this tool with caution. Forcibly unlocking a state file can lead to state corruption if another operation is still in progress.
- Always ensure no other Terraform operations are running before unlocking.

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please open issues or submit pull requests for improvements.

