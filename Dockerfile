FROM nginx:alpine

COPY src/ /usr/share/nginx/html/ 

EXPOSE 80

CMD ["nginx", "-g", "deamon off;"]

