FROM nginx:alpine
# Copy the static website landing page to the Nginx html directory
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
