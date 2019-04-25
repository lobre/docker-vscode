FROM codercom/code-server as builder

FROM lobre/dotfiles

# Install init utility
RUN sudo apt-get update && sudo apt-get install -y dumb-init

# Copy code-server from builder image
COPY --from=builder /usr/local/bin/code-server /usr/local/bin/code-server

# Link custom settings
RUN mkdir -p /home/dev/.local/share/code-server/User && \
    ln -s /home/dev/.config/dotfiles/graphical/.config/Code/User/settings.json /home/dev/.local/share/code-server/User/settings.json && \
    ln -s /home/dev/.config/dotfiles/graphical/.config/Code/User/keybindings.json /home/dev/.local/share/code-server/User/keybindings.json

# Install custom extensions
COPY ./code-ext-install /usr/local/bin/
RUN code-ext-install

EXPOSE 8443

ENTRYPOINT ["dumb-init", "code-server"]
CMD ["--allow-http", "--no-auth"]
