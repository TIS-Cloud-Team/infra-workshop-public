# Infra Workshop Repository

Welcome to the Infra Workshop repository! This repository is intended for general learning purposes, focusing on infrastructure-related topics and workshops.

## 🚨 Important Guidelines

To maintain the security and integrity of both your personal information and our organization’s data, please adhere to the following guidelines when contributing:

1. **Avoid Committing Sensitive Information**

   - **Do Not** include any credentials, API keys, passwords, or secret tokens in your code or configuration files.
   - **Do Not** check in any proprietary or confidential organizational data.
2. **Use Environment Variables**

   - Store sensitive information in environment variables or secure vaults.
   - Refer to [Best Practices for Managing Secrets](https://example.com/best-practices) for more information.
3. **Review Before Committing**

   - Double-check your commits to ensure no sensitive data is being pushed.
   - Use tools like [GitGuardian](https://www.gitguardian.com/) to scan for accidental exposures.
4. **Personal Information**

   - Refrain from including personal identifiable information (PII) in any files within the repository.

## 📚 Purpose of This Repository

This repository serves as a learning platform for individuals interested in infrastructure management, DevOps practices, and related workshops. Feel free to explore, experiment, and contribute to enhance your understanding and skills.

## 📝 Contribution Guidelines

If you'd like to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or fix.
3. Ensure your code adheres to the [Important Guidelines](#important-guidelines).
4. Submit a pull request with a clear description of your changes.

For more detailed information, please refer to the [CONTRIBUTING.md](CONTRIBUTING.md) file.

### Additional Recommendations:

1. **Add a `.gitignore` File**: Ensure that files containing sensitive information (like `.env` files) are excluded from the repository by adding them to your `.gitignore`.

   ```gitignore
   # Environment Variables
   .env
   ```
2. **Use Git Hooks**: Implement pre-commit hooks to automatically prevent committing sensitive files. Tools like [Husky](https://github.com/typicode/husky) can help set this up.
3. **Provide Templates**: Offer template files (e.g., `.env.example`) that contributors can copy and configure locally without exposing actual secrets.
4. **Regular Audits**: Periodically review the repository for accidental exposures using automated tools.

By incorporating these guidelines and practices, you help ensure that your repository remains secure and focused on its educational objectives.
