class TasksController < ApplicationController
# 一覧
def index
  # クエリストリングにis_loopがあるか確認
  if params[:is_loop]
    # ANDを用いて検索
    @tasks =Task.where('is_loop & ? >0',params[:is_loop].to_i)
  else
  # タスクの一覧を取得
  @tasks = Task.all
  end
end

# 新規作成ページ
def new
  # タスクの空インスタンスを定義
  @tasks = Task.new
end

# 新規作成処理
def create
  # is_loopが送られているかを確認
  unless task_params[:is_loop].nil?
    # 選択された値を取得
    selected_values = task_params[:is_loop].map(&:to_i)
    
    # 選択された値をビットマスクに変換
  　is_loop_mask = selected_values.reduce(0) { |sum, value| sum | value }
  end
    
    # @taskに登録用のデータをまとめて挿入
  @task = Task.new(task_params.merge(is_loop: is_loop_mask))
  
  # タスクを保存
  if @task.save
    # タスクの一覧ページへ遷移
    redirect_to tasks_path,notice: "タスクを削除しました。"
  else
    # newページを再レンダリング
    render :new
  end
end
 
# 削除処理
def destroy
  # URLに含まれているidから削除するタスクを検索
  @task = Task.find(params[:id])
  # タスクを削除
  @task.destroy
  # タスクの一覧ページに遷移
    redirect_to tasks_path, notice: "タスクを削除しました。"
end

protected

# パラメータ取得用のメソッド
def task_params
  params.require(:task).permit(:name, :body, is_loop: [])
end
end
