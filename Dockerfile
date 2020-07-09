FROM jekyll/jekyll

COPY Gemfile .
RUN bundle install

COPY . .

EXPOSE 4000
CMD jekyll serve