# Discord Police

![](https://media1.tenor.com/images/3d596ad88741269a62e73d75c81afde4/tenor.gif?itemid=9529075)

Check your files for leaked discord bot tokens before you commit your files.

## Install

```
npm install --save-dev discord-police husky
```

## Using as a pre-commit hook

```json
{
  "name": "my-discord-bot",
  "version": "1.0.0",
  "devDependencies": {
    "discord-police": "1.0.0",
    "husky": "^3.0.0"
  },
  // add this part
  "husky": {
    "hooks": {
      "pre-commit": "discord-police --dir src"
    }
  }
}
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

Files and folders ignored by default: `node_modules, dist, .git, output`
