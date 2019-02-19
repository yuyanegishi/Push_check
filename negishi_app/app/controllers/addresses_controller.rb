class AddressesController < ApplicationController

  def show
    if logged_in?
      @address = Address.find(params[:id])
    else
      redirect_to books_path, flash: {danger: "ログイン、またはユーザー登録を行なってください"}
    end
  end

  def new
    if logged_in?
      @address = Address.new
    else
      redirect_to books_path, flash: {danger: "ログイン、またはユーザー登録を行なってください"}
    end
  end

  def create
    @address = Address.new(address_params)
    if @address.save
      flash[:success] = "住所の登録が完了しました!"
      redirect_to @address
    else
      render 'new'
    end
  end

  def index
    if logged_in?
      @cartitems = current_user.cart_items
      if @cartitems.empty?
        redirect_to books_path, flash: {danger: "商品を選択の上購入手続きを行なってください"}
      else
        # 在庫切れ商品のピックアップ
        @errorpoint_stock = []
        @cartitems.each do | cartitem |
          if cartitem.quantity > cartitem.book.stock
            @errorpoint_stock << cartitem.book_id
          end
        end

        if @errorpoint_stock.empty?
          @addresses = current_user.addresses
          if @addresses.empty?
            redirect_to registration_path, flash: {danger: "住所を登録の上購入手続きを行なってください"}
          end
        else
          # 在庫不足により、再度購入手続きへ
          @message_stock = ""
          @errorpoint_stock.each do | book_id |
            @insufficient_book = Book.find_by(id: book_id)
            @message_stock << "#{@insufficient_book.title} "
          end
          redirect_to cart_items_path, flash: {danger: "#{@message_stock}の在庫が不足しています。再度確認の上購入手続きを行なってください"}
        end
      end
    else
      redirect_to books_path, flash: {danger: "ログイン、またはユーザー登録を行なってください"}
    end
  end

  private

    def address_params
      params.require(:address).permit(:consignee, :first_postal_code, :last_postal_code, :first_address, :second_address, :phone, :user_id)
    end

end
