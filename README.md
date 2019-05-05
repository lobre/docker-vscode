# docker-vscode

Web based VsCode with all personal configuration

    docker run --rm --name vscode -it -p 8443:8443 lobre/vscode

Then open your browser on http://localhost:8443 and you can code!

To update from dotfiles: `code-update`.
To simply update extensions: `code-ext-install`.
To re-apply web settings: `code-web-settings`.
