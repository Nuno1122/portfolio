const MODAL_DISPLAY_TRUE = 'true';  // クエリパラメーター "achieved" の値
const HIDDEN_CLASS = 'hidden';    // モーダルを非表示にするためのクラス

document.addEventListener('turbo:load', () => {       // turbolinks:load イベントリスナー
  const modal = document.getElementById('modal');     // モーダルの要素を取得
  const modalBackdrop = document.getElementById('modal-backdrop');    // モーダルの要素を取得
  // If modal does not exist, stop execution.
  if (!modal || !modalBackdrop) return;            // モーダルが存在しない場合は処理を中断

  const closeModalButton = document.getElementById('close-modal');  // モーダルの要素を取得


  const params = new URLSearchParams(window.location.search); // URLSearchParams オブジェクトを生成
  const achieved = params.get('achieved');  // クエリパラメーター "achieved" の値を取得

  const achievedCount = parseInt(modal.dataset.achievedCount);  // 朝活達成日数を取得
  const previousAchievedCount = parseInt(modal.dataset.previousAchievedCount);    // 前回の朝活達成日数を取得
  const currentMonth = new Date().getMonth() + 1; // 今月の月を取得

  const firstTimeMessage = 'おめでとうございます！今月初めての朝活成功をしました！これからも継続して朝活を行い、目標達成に向けて一緒に頑張りましょう！素晴らしいスタートですね！';  

  const randomMessages = generateRandomMessages(currentMonth, achievedCount); // ランダムなメッセージリストを生成

  // 朝活達成時の処理
if (achieved === MODAL_DISPLAY_TRUE) {
  displayAchievementMessage(modal, previousAchievedCount, achievedCount, firstTimeMessage, randomMessages); // 朝活達成時のメッセージを表示
  modalBackdrop.classList.remove(HIDDEN_CLASS); // モーダルの背景を表示
  modal.classList.add('fade-in'); // モーダルをフェードイン
}

// モーダルを閉じるイベントリスナー
closeModalButton.addEventListener('click', () => {  // モーダルの閉じるボタンをクリックした時
  closeModalAndUpdateUrl(modal, params);  // モーダルを閉じてURLを更新
  modalBackdrop.classList.add(HIDDEN_CLASS);  // モーダルの背景を非表示
  modal.classList.remove('fade-in');  // モーダルをフェードアウト
});

});


// ランダムなメッセージリストを生成する関数
function generateRandomMessages(currentMonth, achievedCount) {  
  
  // メッセージの定義
  const messages = [
  `すごい！${currentMonth}月は既に${achievedCount}日間朝活に成功しています！この調子で前進しましょう！`,
    `お見事！${currentMonth}月は今日で${achievedCount}日朝活成功です！目標達成まであと一息ですね！`,
    `素晴らしい成果！${currentMonth}月はこれで${achievedCount}日間朝活成功！さらなる高みを目指しましょう！`,
    `すごい！${currentMonth}月は既に${achievedCount}日間朝活に成功しています！この調子で前進しましょう！`,
    `素晴らしい成果！${currentMonth}月はこれで${achievedCount}日間朝活成功！さらなる高みを目指しましょう！`,
    `朝活達成${achievedCount}日目！${currentMonth}月も元気にスタート！継続の力を信じて、頑張りましょう！`,
    `${currentMonth}月は${achievedCount}日間朝活成功！目標を見失わず、一歩一歩進みましょう！`,
    `${currentMonth}月はすでに${achievedCount}日間朝活達成！このまま続けて、目標をクリアしましょう！`,
    `やりましたね！${currentMonth}月は${achievedCount}日間朝活成功！毎日の努力が確実に成果につながっています！`,
    `お疲れ様です！${currentMonth}月はこれで${achievedCount}日間朝活達成！持続的な努力が大切ですね！`,
    `${currentMonth}月は${achievedCount}日間朝活達成！目標達成に向けて、一緒に頑張りましょう！`,
    `朝活達成率が上がっています！${currentMonth}月はすでに${achievedCount}日間成功！この勢いでさらに頑張りましょう！`,

    `${currentMonth}月も${achievedCount}日間朝活成功！継続していくことで、夢が現実に近づいていきます！`,
    `すばらしい継続力！${currentMonth}月は${achievedCount}日間朝活達成！一日一日の積み重ねが大切ですね！`,
    `${currentMonth}月はこれで${achievedCount}日間朝活成功！夢に向かって邁進しましょう！`,
    `お疲れ様です！${currentMonth}月も${achievedCount}日間朝活達成！自分へのご褒美を忘れずに！`,
`${currentMonth}月は${achievedCount}日間朝活成功！一歩ずつでも確実に進んでいます！`,
`${currentMonth}月も${achievedCount}日間朝活達成！素晴らしい努力を続けましょう！`,
`朝活達成${achievedCount}日目！${currentMonth}月も絶好調です！引き続き頑張りましょう！`,
`${currentMonth}月はこれで${achievedCount}日間朝活成功！努力が実り、大きな成果へと繋がります！`,
`${currentMonth}月は${achievedCount}日間朝活達成！継続は力なり、素晴らしい成果を生み出します！`,
`${currentMonth}月も${achievedCount}日間朝活成功！自分を信じて、目標に向かって進みましょう！`,
`${currentMonth}月はこれで${achievedCount}日間朝活達成！勇敢なあなたを称えましょう！`,

`やりましたね！${currentMonth}月は${achievedCount}日間朝活成功！自分に自信を持ち、さらなる高みへ！`,
`${currentMonth}月も${achievedCount}日間朝活達成！素晴らしい継続力が明るい未来を切り開きます！`,
`${currentMonth}月はこれで${achievedCount}日間朝活成功！あなたの努力は大きな変化を生み出しています！`,
`おめでとう！${currentMonth}月は${achievedCount}日間朝活達成！毎日のチャレンジがあなたを成長させます！`,
`${currentMonth}月も${achievedCount}日間朝活成功！このままのペースで前進し続けましょう！`,
`${currentMonth}月はこれで${achievedCount}日間朝活達成！あなたの努力は周りにも良い影響を与えます！`,
`${currentMonth}月は${achievedCount}日間朝活成功！自分を褒めて、エネルギーをチャージしましょう！`,
`${currentMonth}月も${achievedCount}日間朝活達成！継続していくことで、無限の可能性が広がります！`,
`${currentMonth}月はこれで${achievedCount}日間朝活成功！進む道を信じて、躍進しましょう！`,
`お疲れ様です！${currentMonth}月は${achievedCount}日間朝活達成！この調子で明日も頑張りましょう！`,

`すばらしい！${currentMonth}月は${achievedCount}日間朝活成功！毎日の小さな努力があなたの力になります！`,
`${currentMonth}月も${achievedCount}日間朝活達成！あなたの努力は素晴らしい成果をもたらします！`,
`${currentMonth}月はこれで${achievedCount}日間朝活成功！継続することで、新たな目標に挑戦できます！`,
`努力が報われました！${currentMonth}月は${achievedCount}日間朝活達成！あなたの頑張りに敬意を表します！`,
`${currentMonth}月も${achievedCount}日間朝活成功！一つひとつの達成が、あなたの自信につながります！`,
`${currentMonth}月はこれで${achievedCount}日間朝活達成！あなたの持続力は素晴らしい成長をもたらします！`,
`${currentMonth}月は${achievedCount}日間朝活成功！継続することで、あなたの可能性は無限に広がります！`,
`${currentMonth}月も${achievedCount}日間朝活達成！あなたの努力は人生をより豊かにします！`,
`${currentMonth}月はこれで${achievedCount}日間朝活成功！目標達成への道は一歩ずつ進むことが大切です！`,
`素晴らしい！${currentMonth}月は${achievedCount}日間朝活達成！この調子でさらなる目標にチャレンジしましょう！`,

`やり遂げました！${currentMonth}月は${achievedCount}日間朝活成功！あなたの成長を感じる瞬間です！`,
`${currentMonth}月も${achievedCount}日間朝活達成！あなたの意志力が次のステップへと導きます！`,
`${currentMonth}月はこれで${achievedCount}日間朝活成功！毎日の継続があなたを強くします！`,
`素晴らしい努力！${currentMonth}月は${achievedCount}日間朝活達成！あなたのパワーは限界を超えています！`,
`${currentMonth}月も${achievedCount}日間朝活成功！あなたの活力が周りにも伝染し、みんなを元気にします！`,
`${currentMonth}月はこれで${achievedCount}日間朝活達成！あなたの情熱が大きなインパクトを生み出します！`,
`朝活達成で${currentMonth}月は${achievedCount}日間成功！あなたの素晴らしい継続力を讃えましょう！`,

`おめでとうございます！${currentMonth}月は${achievedCount}日間朝活達成！あなたの努力は目標に近づく力になります！`,
`${currentMonth}月も${achievedCount}日間朝活成功！あなたの決断力が素晴らしい成果を生んでいます！`,
`${currentMonth}月はこれで${achievedCount}日間朝活達成！あなたの継続力が新たな扉を開きます！`,
`素晴らしい達成感！${currentMonth}月は${achievedCount}日間朝活成功！あなたの前途は明るく輝いています！`,
`${currentMonth}月も${achievedCount}日間朝活達成！あなたの行動力が新しい道へと導いてくれます！`,
`${currentMonth}月はこれで${achievedCount}日間朝活成功！あなたの勇敢な姿勢が大きな成果を引き寄せます！`,
`${currentMonth}月もあと${31 - achievedCount}日！引き続きがんばりましょう！`,
`すごい！！朝活達成！${currentMonth}月は${achievedCount}日間成功！あなたの行動力が夢を現実にします！`
  ];
  return messages;
}

// 朝活達成時のメッセージを表示する関数
function displayAchievementMessage(modal, previousAchievedCount, achievedCount, firstTimeMessage, randomMessages) {   //朝活達成時のメッセージを表示する関数
  if (previousAchievedCount === 0 && achievedCount === 1) { // 今月初めての朝活達成の場合
    console.log('Displaying first time message');   // 今月初めての朝活達成のメッセージを表示
    document.getElementById("modal-content").innerHTML = firstTimeMessage;  // 今月初めての朝活達成のメッセージを表示
  } else {
    console.log('Displaying random message'); // ランダムなメッセージを表示
    const randomIndex = Math.floor(Math.random() * randomMessages.length);  // ランダムなインデックスを生成
    document.getElementById("modal-content").innerHTML = randomMessages[randomIndex]; // ランダムなメッセージを表示
  }
  modal.classList.remove(HIDDEN_CLASS); // モーダルを表示
}

// モーダルを閉じてURLを更新する関数
function closeModalAndUpdateUrl(modal, params) {  // モーダルを閉じてURLを更新する関数
  modal.classList.add(HIDDEN_CLASS);  // モーダルを非表示

  // クエリパラメーター "achieved" を削除し、ページ URL を更新
  params.delete('achieved');  // クエリパラメーター "achieved" を削除
  window.history.replaceState({}, '', `${location.pathname}?${params}`);  // ページ URL を更新
}