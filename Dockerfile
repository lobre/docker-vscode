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

# Add web specific configurations
COPY settings.web.json /home/dev/.local/share/code-server/User/settings.web.json

# Add custom scripts
COPY ./scripts/code-update /usr/local/bin/
COPY ./scripts/code-web-settings /usr/local/bin/
COPY ./scripts/code-ext-install /usr/local/bin/

# Adjust permissions
RUN sudo chmod +x /usr/local/bin/code-update \
    /usr/local/bin/code-web-settings \
    /usr/local/bin/code-ext-install

# Apply web settings and install extensions
RUN code-update

EXPOSE 8443

ENTRYPOINT ["dumb-init", "code-server"]
CMD ["--allow-http", "--no-auth"]