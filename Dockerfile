FROM nginx:alpine
# Use lightweight Nginx Alpine image as base

# Copy the contents of html folder into the default Nginx web root directory
COPY html/ /usr/share/nginx/html
# Copy entire html directory to Nginx web root

# The default Nginx port is 80, so we expose it
EXPOSE 80
# Expose port 80 for web traffic

CMD ["nginx", "-g", "daemon off;"]
# Start Nginx server in foreground mode