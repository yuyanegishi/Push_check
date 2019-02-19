class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @cartitem = CartItem.new
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      flash[:success] = "商品の登録が完了しました!"
      redirect_to @book
    else
      render 'new'
    end
  end

  def index
    @books = Book.all
  end

  private

    def book_params
      params.require(:book).permit(:title, :author, :overview, :price, :stock, :picture)
    end

end
