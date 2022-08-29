FROM node:lts-alpine as build-stage
WORKDIR /api_to_automate_frontend
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build-only
EXPOSE 4173
CMD ["npm", "run", "dev"]


FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /api_to_automate_frontend/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]