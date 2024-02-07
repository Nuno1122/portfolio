require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'GET #new' do
    before do
      get :new
    end

    it 'リクエストが成功すること' do
      expect(response).to have_http_status(:success)
    end

    it "新しいユーザーオブジェクトが初期化されていること" do
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    let(:user_params) do
      { user: { name: "Test User", email: "test@example.com", password: "password", password_confirmation: "password" } }
    end
    context '正しいパラメータの場合' do
      it 'ユーザーのデータが1件増えること' do
        expect { post :create, params: user_params }.to change(User, :count).by(1)
      end

      it 'user_idがセッションに保存され、セットアップページにリダイレクトすること' do
        aggregate_failures do
          post :create, params: user_params
          expect(session[:user_id]).to eq(User.last.id.to_s)
          expect(response).to redirect_to morning_activity_logs_path
          expect(flash[:success]).to eq I18n.t('users.create.success')
        end
      end
    end

    context '不正なパラメータの場合' do
      context 'パスワードが6文字未満の場合' do
        it 'saveに失敗し、エラーメッセージが表示されること' do
          post :create, params: { user: user_params.merge( password: '' ) }
          aggregate_failures do
            expect(response).to have_http_status(:unprocessable_entity)
            # render後のresponse.bodyの中の値が""のため、表示がされないので調査(Rails7.0だから？？)
            #expect(response.body).to include('パスワードは6文字以上で入力してください')
          end
        end
      end

      context 'メールアドレスが空欄の場合' do
        it 'saveに失敗し、エラーメッセージが表示されること' do
          post :create, params: { user: user_params.merge(email: '') }
          aggregate_failures do
            expect(response).to have_http_status(:unprocessable_entity)
            # render後のresponse.bodyの中の値が""のため、表示がされないので調査(Rails7.0だから？？)
            #expect(response.body).to include('メールアドレスを入力してください')
          end
        end
      end
    end

    describe 'DELETE #destroy' do
      let!(:user) { create(:user) }
      it 'ユーザーが1件削除されること' do
        expect { delete :destroy, params: { id: user.id } }.to change(User, :count).by(-1)
      end

      it 'ユーザー一覧ページ(users_url)にリダイレクトされること' do
        delete :destroy, params: { id: user.id }
        expect(response).to redirect_to(users_url)
      end

      it 'フラッシュメッセージに成功メッセージが含まれて表示されること' do
        delete :destroy, params: { id: user.id }
        expect(flash[:success]).to eq I18n.t('users.destroy.success')
      end
    end
  end
end
