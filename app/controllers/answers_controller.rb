# frozen_string_literal: true

class AnswersController < ApplicationController
  skip_before_action :require_login, only: %i[show] # 解答詳細はログイン不要

  def index; end

  def new
    @question = Question.includes({ departments: [:university] }).find(params[:question_id])
    answer_id = current_user.question_id_to_answer_id_hash[@question.id]
    if answer_id
      # 当該の問題の解答を既に作成している場合は編集ページへredirect
      redirect_to edit_answer_path(answer_id)
    else
      # 解答未作成の場合は新規作成ページへ
      @answer = Answer.new
      @tex = @answer.build_tex
      set_tag_suggestions
    end
  end

  def create
    @question = Question.includes({ departments: [:university] }).find(params[:question_id])
    @answer = current_user.answers.new(question_id: params[:question_id], point: answer_params[:point], tag_list: answer_params[:tag_list], files: answer_params[:files])
    set_tex
    if @answer.save
      redirect_to @answer, success: t(".success")
    else
      # save失敗時は必ずfilesが不正なので、それをnilにする
      @answer.files = nil
      flash.now[:danger] = t(".fail")
      render "answers/new"
    end
  end

  def show
    @answer = Answer.includes(question: { departments: [:university] }).with_attached_files.find(params[:id])
    set_question
  end

  def edit
    @answer = Answer.includes(question: { departments: [:university] }).with_attached_files.find(params[:id])
    set_question
    set_tag_suggestions
  end

  def update
    @answer = Answer.includes(question: { departments: [:university] }).with_attached_files.find(params[:id])

    set_tex
    if @answer.update(answer_params)
      redirect_to @answer, success: t(".success")
    else
      # update失敗はファイル登録失敗時のみ
      # ファイル登録失敗時は、エラーメッセージと共に、元々登録されていたファイルを表示する
      @answer.files = Answer.find(params[:id]).files.blobs
      flash.now[:danger] = t(".fail")
      render "answers/edit"
    end
  end

  def destroy
    @answer = Answer.includes(question: { departments: [:university] }).with_attached_files.find(params[:id])
    @question = @answer.question
    @answer.destroy!
    redirect_to @question, success: t(".success")
  end

  private

  def answer_params
    params.require(:answer).permit(:point, :tag_list, files: [])
  end

  def tex_params
    params.require(:answer).permit(tex: %i[code pdf_blob_signed_id id _destroy])[:tex]
  end

  # texにpdfをattachし、texをanserに関連づける
  def set_tex
    if @answer.tex.nil?
      @tex = @answer.build_tex(tex_params)
    else
      @tex = @answer.tex
      @tex.update(tex_params)
    end
    # texにpdfをattachする
    @tex.attach_pdf
  end

  # question をセット
  def set_question
    @question = @answer.question
  end

  # ユーザーが同じ分野の問題につけたタグの一覧を取得する
  def set_tag_suggestions
    gon.tags = @question.tags_belongs_to_same_unit_of_user(current_user).map(&:name)
  end
end
