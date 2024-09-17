FROM ruby:2.7.8

# Instala dependências básicas
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libsqlite3-dev \
  nodejs \
  yarn

# Configura diretório de trabalho
WORKDIR /app

# Copia o Gemfile e o Gemfile.lock para a imagem
COPY Gemfile Gemfile.lock ./

# Instala as gems
RUN gem install bundler -v 2.2.33
RUN bundle install

# Copia o restante do código da aplicação
COPY . .

# Prepara os assets (necessário por causa do Bootstrap)
RUN bundle exec rake assets:precompile

# Expõe a porta que a aplicação vai usar
EXPOSE 3000

# Comando para iniciar o servidor Rails
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
