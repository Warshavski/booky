# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Api::V1::Admin::AuthorsController
      #
      #   Used to manage books authors(CRUD)
      #
      class AuthorsController < ApplicationController

        set_default_serializer AuthorSerializer

        # GET : api/v1/admin/authors
        #
        #   optional query parameters :
        #
        #     - standard filters (@see filter_params)
        #
        #     - book_id   filter by book
        #                   example: ?book_id=1
        #
        # Get a list of authors
        #
        def index
          authors = filter_authors(filter_params)

          render_resource authors, is_collection: true, status: :ok
        end

        # GET : api/v1/admin/authors/{:id}
        #
        # Get a specific author identified by id
        #
        def show
          author = filter_authors.find_by(id: params[:id])

          process_record(author) do |a|
            render_resource a, status: :ok
          end
        end

        # POST : api/v1/admin/authors
        #
        # Create a new author
        #
        def create
          author = Author.create!(authors_params)

          render_resource author, status: :created
        end

        # PATCH/PUT : api/v1/admin/authors/{:id}
        #
        # Update information about author
        #
        def update
          author = filter_authors.find_by(id: params[:id])

          process_record(author) do |p|
            p.update!(authors_params)

            head :no_content
          end
        end

        # DELETE : api/v1/admin/authors/{:id}
        #
        # Delete author from storage
        #
        def destroy
          author = filter_authors.find_by(id: params[:id])

          process_record(author) do |p|
            p.destroy!

            head :no_content
          end
        end

        private

        def filter_authors(filters = {})
          AuthorsFinder.new(filters).execute
        end

        def specific_filters
          [:book_id]
        end

        def authors_params
          restify_param(:author)
            .require(:author)
            .permit(:last_name, :first_name, :biography, :born_in, :died_id)
        end
      end
    end
  end
end