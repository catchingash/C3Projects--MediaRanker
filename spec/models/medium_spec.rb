require 'rails_helper'

RSpec.describe Medium, type: :model do
  describe "attributes" do
    [:title, :creator, :votes, :description, :format].each do |method_name|
      it { is_expected.to respond_to method_name}
    end

    context "when creating default media" do
      it "votes are set to 0" do
        expect(subject.votes).to eq(0)
      end

      it "description is set to ''" do
        expect(subject.description).to eq('')
      end

      it "creator is set to ''" do
        expect(subject.creator).to eq('')
      end
    end
  end

  describe "model methods" do
    describe "indexes for specific formats" do
      before :all do
        @record1 = Medium.create({ :title=>"Kitties Album", :creator=>"Cat", :votes=>9, :description=>"", :format=>"album" })
        @record2 = Medium.create({ :title=>"Llamas Movie", :creator=>"The Llama", :votes=>6, :format=>"movie" })
        @record3 = Medium.create({ :title=>"Puppies Album", :creator=>"Dog", :votes=>10, :description=>"", :format=>"album" })
        @record4 = Medium.create({ :title=>"Elephants Album", :creator=>"Elephant", :description=>"", :format=>"album" })
        @record5 = Medium.create({ :title=>"Puppies Book", :creator=>"Dog", :votes=>10, :description=>"", :format=>"book" })
        @record6 = Medium.create({ :title=>"Llamas Album", :creator=>"The Llama", :votes=>6, :description=>"", :format=>"album" })
        @record7 = Medium.create({ :title=>"Kitties Movie", :creator=>"Cat", :votes=>9, :format=>"movie" })
        @record8 = Medium.create({ :title=>"Puppies Movie", :creator=>"Dog", :votes=>10, :format=>"movie" })
        @record9 = Medium.create({ :title=>"Kitties Book", :creator=>"Cat", :votes=>9, :description=>"", :format=>"book" })
        @record10 = Medium.create({ :title=>"Llamas Book", :creator=>"The Llama", :votes=>6, :description=>"", :format=>"book" })
        @record11 = Medium.create({ :title=>"Elephants Book", :creator=>"Elephant", :description=>"", :format=>"book" })
        @record12 = Medium.create({ :title=>"Elephants Movie", :creator=>"Elephant", :description=>"", :format=>"movie" })
      end

      after :all do
        Medium.destroy_all
      end

      describe ".movies" do
        it "returns all the movies" do
          expect(Medium.movies).to include(@record2, @record7, @record8, @record12)
        end

        it "exludes other formats" do
          expect(Medium.movies.count).to eq (4)
        end
      end

      describe ".books" do
        it "returns all the books" do
          expect(Medium.books).to include(@record5, @record9, @record10, @record11)
        end

        it "exludes other formats" do
          expect(Medium.books.count).to eq (4)
        end
      end

      describe ".albums" do
        it "returns all the albums" do
          expect(Medium.albums).to include(@record1, @record3, @record4, @record6)
        end

        it "exludes other formats" do
          expect(Medium.albums.count).to eq (4)
        end
      end
    end

    describe ".best" do
      before :each do
        @medium1 = Medium.create({ title: "Llamas Album", creator: "The Llama", votes: 6, format: "album" })
        @medium2 = Medium.create({ title: "Fishies Movie", creator: "Fish", format: "movie" })
        @medium3 = Medium.create({ title: "Kitties Album", creator: "Cat", votes: 9, format: "album" })
        @medium4 = Medium.create({ title: "Puppies Movie", creator: "Dog", votes: 10, format: "movie" })
      end

      context "when passed a limit of 2" do
        it "returns top 2 media" do
          expect(Medium.best(2)).to include(@medium3, @medium4)
        end

        it "exludes other media" do
          expect(Medium.best(2)).to_not include(@medium1, @medium2)
        end
      end
    end

    describe ".best for a specific format" do
      before :all do
        @record1 = Medium.create({ :title=>"Kitties Album", :creator=>"Cat", :votes=>9, :description=>"", :format=>"album" })
        @record2 = Medium.create({ :title=>"Llamas Movie", :creator=>"The Llama", :votes=>6, :format=>"movie" })
        @record3 = Medium.create({ :title=>"Puppies Album", :creator=>"Dog", :votes=>10, :description=>"", :format=>"album" })
        @record4 = Medium.create({ :title=>"Elephants Album", :creator=>"Elephant", :description=>"", :format=>"album" })
        @record5 = Medium.create({ :title=>"Puppies Book", :creator=>"Dog", :votes=>10, :description=>"", :format=>"book" })
        @record6 = Medium.create({ :title=>"Llamas Album", :creator=>"The Llama", :votes=>6, :description=>"", :format=>"album" })
        @record7 = Medium.create({ :title=>"Kitties Movie", :creator=>"Cat", :votes=>9, :format=>"movie" })
        @record8 = Medium.create({ :title=>"Puppies Movie", :creator=>"Dog", :votes=>10, :format=>"movie" })
        @record9 = Medium.create({ :title=>"Kitties Book", :creator=>"Cat", :votes=>9, :description=>"", :format=>"book" })
        @record10 = Medium.create({ :title=>"Llamas Book", :creator=>"The Llama", :votes=>6, :description=>"", :format=>"book" })
        @record11 = Medium.create({ :title=>"Elephants Book", :creator=>"Elephant", :description=>"", :format=>"book" })
        @record12 = Medium.create({ :title=>"Elephants Movie", :creator=>"Elephant", :description=>"", :format=>"movie" })
      end

      after :all do
        Medium.destroy_all
      end

      describe ".best_movies" do
        it "returns top 2 movies when passed 2" do
          expect(Medium.best_movies(2)).to include(@record8, @record7)
        end

        it "exludes other movies" do
          expect(Medium.best_movies(2).count).to eq(2)
        end
      end

      describe ".best_albums" do
        it "returns top 2 albums when passed 2" do
          expect(Medium.best_albums(2)).to include(@record3, @record1)
        end

        it "exludes other albums" do
          expect(Medium.best_albums(2).count).to eq(2)
        end
      end

      describe ".best_books" do
        it "returns top 2 albums when passed 2" do
          expect(Medium.best_books(2)).to include(@record5, @record9)
        end

        it "exludes other books" do
          expect(Medium.best_books(2).count).to eq(2)
        end
      end
    end

    describe "#upvote!" do
      context "when handling a movie" do
        let(:movie){ Medium.create({ title: "Puppies Movie", creator: "Dog", format: "movie" }) }

        it "increases the votes by 1" do
          movie.upvote!
          expect(movie.votes).to eq(1)
        end
      end

      context "when handling an album" do
        let(:album){ Medium.create({ title: "Puppies Album", creator: "Dog", format: "album" }) }

        it "increases the votes by 1" do
          album.upvote!
          expect(album.votes).to eq(1)
        end
      end

      context "when handling a book" do
        let(:book){ Medium.create({ title: "Puppies Book", creator: "Dog", format: "book" }) }

        it "increases the votes by 1" do
          book.upvote!
          expect(book.votes).to eq(1)
        end
      end
    end
  end

  describe ".all_objects" do
    before :all do
      @record1 = Medium.create({ :title=>"Kitties Album", :creator=>"Cat", :votes=>9, :description=>"", :format=>"album" })
      @record2 = Medium.create({ :title=>"Llamas Movie", :creator=>"The Llama", :votes=>6, :format=>"movie" })
      @record3 = Medium.create({ :title=>"Puppies Album", :creator=>"Dog", :votes=>10, :description=>"", :format=>"album" })
      @record4 = Medium.create({ :title=>"Elephants Album", :creator=>"Elephant", :description=>"", :format=>"album" })
      @record5 = Medium.create({ :title=>"Puppies Book", :creator=>"Dog", :votes=>10, :description=>"", :format=>"book" })
      @record6 = Medium.create({ :title=>"Llamas Album", :creator=>"The Llama", :votes=>6, :description=>"", :format=>"album" })
      @record7 = Medium.create({ :title=>"Kitties Movie", :creator=>"Cat", :votes=>9, :format=>"movie" })
      @record8 = Medium.create({ :title=>"Puppies Movie", :creator=>"Dog", :votes=>10, :format=>"movie" })
      @record9 = Medium.create({ :title=>"Kitties Book", :creator=>"Cat", :votes=>9, :description=>"", :format=>"book" })
      @record10 = Medium.create({ :title=>"Llamas Book", :creator=>"The Llama", :votes=>6, :description=>"", :format=>"book" })
      @record11 = Medium.create({ :title=>"Elephants Book", :creator=>"Elephant", :description=>"", :format=>"book" })
      @record12 = Medium.create({ :title=>"Elephants Movie", :creator=>"Elephant", :description=>"", :format=>"movie" })
    end

    after :all do
      Medium.destroy_all
    end

    ["movie", "book", "album"].each do |format_type|
      it "returns all the #{ format_type } when passed '#{ format_type }'" do
        expect(Medium.all_objects(format_type).count).to eq(4)
        expect(Medium.all_objects(format_type).collect(&:format).uniq).to include(format_type)
        expect(Medium.all_objects(format_type).collect(&:format).uniq.count).to eq(1)
      end
    end
  end

  describe "model validations" do
    context "when title is missing" do
      it "does not persist the record" do
        medium = Medium.new

        expect(medium).to_not be_valid
        expect(medium.errors.keys).to include(:title)
      end
    end

    context "when format is missing" do
      it "does not persist the record" do
        medium = Medium.new

        expect(medium).to_not be_valid
        expect(medium.errors.keys).to include(:format)
      end
    end

    context "when format is not one of the recognized types" do
      # TODO: this could be done better, if I had more time :(
      it "is not valid" do
        medium = Medium.new(format: "invalid format")

        expect(medium).to_not be_valid
        expect(medium.errors.keys).to include(:format)
      end
    end
  end
end



