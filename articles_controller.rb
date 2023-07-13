class ArticlesController < ApplicationController
  # http_basic_authenticate_with name: "test", password: "test", except: [:index, :show]
  
  def index
    @articles = Article.all

    # adding this respond_to code block will allow you to render the html if you're in your browser visiting localhost:3000, OR render json if you're making a web request with '.json' at the end (like you do in React)
    respond_to do |format|
      format.html { @articles }
      format.json { render json: @articles.as_json }
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create  
    # I'm now using your new private function instead of explicitly writing out each article attribute. 
    @article = Article.new(article_params)

    if @article.save

      # Again, the respond_to allows you to have a Rails frontend (html) and a React frontend (json)
      respond_to do |format|
        format.html do
          redirect_to @article
        end
        
        format.json do
          render json: @article.as_json
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end

  # this private method, only available in your articles controller, expects a web request that's formatted like this: 
  # { 
  #   "article": {
  #     "title": "Another Test ABC!!!",
  #     "body": "This is a test article",
  #     "status": "public"
  #   }
  # }
  # You now need a key "article", and the value is the json object containing the attributes and their values! You'll most likely need to adjust your React frontend like so: 
  # axios.post("http://localhost:3000/articles.json", {article: params} )
  
  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
end
