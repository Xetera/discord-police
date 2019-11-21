# Discord Police

<img src="https://media1.tenor.com/images/3d596ad88741269a62e73d75c81afde4/tenor.gif?itemid=9529075" width="250">

Check your files for leaked discord bot tokens before you commit to git.

> ⚠️ GitHub now [checks for tokens](https://help.github.com/en/github/administering-a-repository/about-token-scanning) including Discord tokens in public repos and gists automatically. This repo can still be used for other git hosts that don't token scan, but it's now mostly obsolete for GitHub.

## Install

```
npm install --save-dev discord-police husky
```

## Using as a pre-commit hook

Add the following `husky` property to your `package.json`

```json
{
  "name": "my-discord-bot",
  "version": "1.0.0",
  "devDependencies": {
    "discord-police": "1.0.2",
    "husky": "^3.0.0"
  },
  "husky": {
    "hooks": {
      "pre-commit": "discord-police --dir src"
    }
  }
}
```

The next time you commit your files to git, they will automatically be checked for tokens.

#### Example
```
 $ git commit -m "cool changes"
 
husky > pre-commit (node v10.13.0)
[ Discord Police 🚨 ] A discord bot token was found in src/index.js on line 7
husky > pre-commit hook failed (add --no-verify to bypass)
```

## CLI

```
discord-police --dir src --ignore .env,secret_files
```

## Args

`--dir` Directory to search from **Default:** `.`

---

Discord police automatically ignores everything inside your `.gitignore` file. This should already cover almost every single case (since you should be ignoring credential files), but if you really need to...

`--ignore` List of directories/files to ignore separated by commas **Default:** `null`

Files and folders ignored by default: `node_modules`, `dist`, `.git`, `output`

## For non-js projects
The compiled js code is available at https://unpkg.com/discord-police@latest/index.js

You can use the following command to download it and add it as a hook directly
```bash
wget https://unpkg.com/discord-police@latest/index.js -O .git/hooks/pre-commit && chmod +x .git/hooks/pre-commit
```
