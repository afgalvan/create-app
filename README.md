# **create-app.**

Basic template manager.

## Requirements.

- [git](https://git-scm.com/downloads) ^2.x.

For the installation.

- [curl](https://curl.se/download.html)
- [wget](https://www.gnu.org/software/wget/)

---

## Usage

```
create-app <project-name> [template] [package-manager](for web projects)
```

## **To install template manager (create-app).**

### **Install it with curl:**

```
curl -sL https://raw.githubusercontent.com/afgalvan/create-app/main/installer.sh | bash -s  [branch] [package-manager]
```

The package-manager argument it's optional, **npm** is configured by default.

### **Create a new alias:**

bash

> ```
> echo "alias create-app=\"~/.config/create-app/create_app.sh\"" >> ~/.bashrc
> ```

zsh

> ```
> echo "alias create-app=\"~/.config/create-app/create_app.sh\"" >> ~/.zshrc
> ```

---

## **Manually specific template download.**

### 1. Get the template.

Clone the repository with git by:

```
git clone -b <branchname> https://github.com/afgalvan/create-app/.git <new-project-name>
```

or

```
gh repo clone afgalvan/create-app <new-project-name> -- -b <branchname>
```

### 2. Create your own project.

Go your project directory:

```
cd <new-project-name>
```

Delete the git folder:

```
rm -rf .git/
```

Initialize a new git project:

- In git ^2.28.0:
  ```
  git init -b main
  ```
- In older versions:
  ```
  git init
  ```
  ```
  git checkout -b main
  ```
