# Discord Police

<img src="https://media1.tenor.com/images/3d596ad88741269a62e73d75c81afde4/tenor.gif?itemid=9529075" width="250">

Check your files for leaked discord bot tokens before you commit to git.

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
