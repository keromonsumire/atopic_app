# YOUR PROJECT TITLE atocon
#### Video Demo:  <https://youtu.be/o_x6o87gAf0>
#### Description:
　このアプケーションはアトピーの薬の塗布スケジュールを管理し、塗布記録を残すことを目的としたアプリケーションである。
①使用技術
　ruby on rails
②ログイン機構について
　railsのgem 'devise'を使用して構築した。
③データベース設計について
　users table, regions table, histories tableの三つで構成されている。userとregionは１対多、regionとhistoryは1対多の関係となっている。
④機能説明
　部位一覧では、部位の登録、編集、削除が行える。部位はregionsテーブルで管理されている。各カラムは、Region id:string, name:string, user_id:integer(外部キー), interval(薬を塗る間隔、1=毎日、2=1日おき・・・7=一週間おき):integer, morning(朝塗る予定か):boolean, noon(昼塗る予定か):boolean, night(夜塗る予定か):boolean,start(間隔の起点となる日付):date, medicin:stringである。登録ではmそれぞれの項目をform_withによるフォームで入力し、createアクションで作成する。startに関しては現在の日付が自動的に入力される。編集も同様にform_withによるフォームで入力して情報をアップデートする。region modelにはvalidationがついており、nameとintervalは必ず入力する必要がある。(入力しないと保存に失敗する)削除では、部位を削除することができ、部位を削除すると対応するhistoryも同時に削除される。削除ボタンを押すと警告アラートが出てきて、それに同意すると削除が完了する。今日塗るリストに追加ボタンを押すと、startが今日の日付にアップデートされる。部位一覧はmedicinのASC順でソートされている。
　本日のお薬ページ(トップページ)では、今日塗るお薬が朝、昼、夜、昨晩の4つに分かれて表示されている。それぞれ分かれている塗りましたボタンを押すことで、historiesテーブルに記録が保存される。historiesテーブルの各カラムは、History id:integer, regions_id:integer(外部キー),date(年と日付):date,time(morning/noon/night):string, is_yesterday:booleanである。 
　今日塗る薬リストの作成には、regionテーブルの値を用い、今日の日付とstartの日付の差分を求め、intervalで割った際の余りを求め、ゼロのものだけ朝、昼、夜、昨晩の対応するリストに追加する。historiesテーブルを参照して、その時間帯にデータがない場合のみそのリストを表示する。リストはmedicinのASC順でソートされている。全ての時間帯でhistoryに記録があるもしくはリストが存在しない場合は、今日のお薬は全て塗りましたを表示する。今日の判定は、3:59までは前日の判定となる。これは夜遅くに薬を塗った際に薬リストが表示されない問題を解決するためである。また、10:59までは昨晩の薬を塗った記録がない場合は、昨晩の薬のリストが表示される。塗りましたボタンを押すと、今朝塗った記録が保存される。(historyのis_yesterdayをtrueにすることで、朝の薬を塗った判定にしないようにしており、また朝の薬一覧から昨晩の薬を削除する仕様になっている)
　記録一覧では、histories tableに保存された記録を表形式で閲覧することができる。初期状態では今月の表が表示され、行が日付、列が部位名を表している。部位ごとに日付に応じた記録数をカウントして、カウント数に応じてCSSのセレクタ名を配列に保存し、erb上でループする際にcssのclassに代入する処理を行うことで、セルのバックグラウンドカラーを変更することで回数に応じて色が変わる表を作り上げている。前の月へボタンを押すと、prev_monthアクションが呼び出され、session[:month]の値がなければ0に初期化した後、session[:month]の値を-1する。このsession[:month]の値を参照して、例えば-1なら1ヶ月前のデータを参照して表を作り上げることができる。次の月へボタンでは、next_monthアクションが呼び出され、session[:month]の値が+1される。
　ユーザー情報変更では、email,passwordを変更することができる。
　使い方ページでは、使い方を文字で説明している。
　

