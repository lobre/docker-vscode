FROM codercom/code-server as builder

FROM lobre/dotfiles

# Install init utility
RUN sudo apt-get update && sudo apt-get install -y dumb-init

# Copy code-server from builder image
COPY --from=builder /usr/local/bin/code-server /usr/local/bin/code-server

# Add custom settings
ADD --chown=dev:dev https://raw.githubusercontent.com/lobre/dotfiles/master/graphical/.config/Code/User/settings.json /home/dev/.local/share/code-server/User/
ADD --chown=dev:dev https://raw.githubusercontent.com/lobre/dotfiles/master/graphical/.config/Code/User/keybindings.json /home/dev/.local/share/code-server/User/

# Install custom extensions
ADD --chown=dev:dev https://raw.githubusercontent.com/lobre/dotfiles/master/graphical/.config/Code/extensions.sh /tmp/
RUN mkdir -p /home/dev/.local/share/code-server/extensions && \
    sed -i 's/code/code-server -e \/home\/dev\/.local\/share\/code-server\/extensions/' /tmp/extensions.sh && \
    chmod +x /tmp/extensions.sh && \
    /tmp/extensions.sh

EXPOSE 8443

ENTRYPOINT ["dumb-init", "code-server"]
CMD ["--allow-http", "--no-auth"]
