import WidgetKit
import SwiftUI

// MARK: - Data Model

struct QuoteEntry: TimelineEntry {
    let date: Date
    let quoteText: String
    let quoteAuthor: String
}

// MARK: - Quotes Data

private struct QuoteData {
    let text: String
    let author: String
}

private let quotes: [QuoteData] = [
    QuoteData(text: "인생은 자전거를 타는 것과 같다. 균형을 잡으려면 계속 움직여야 한다.", author: "알베르트 아인슈타인"),
    QuoteData(text: "당신이 할 수 있다고 생각하든, 할 수 없다고 생각하든, 당신이 옳다.", author: "헨리 포드"),
    QuoteData(text: "천 리 길도 한 걸음부터.", author: "노자"),
    QuoteData(text: "지금 이 순간에 집중하라. 과거는 이미 지나갔고 미래는 아직 오지 않았다.", author: "붓다"),
    QuoteData(text: "성공이란 열정을 잃지 않고 실패에서 실패로 나아가는 것이다.", author: "윈스턴 처칠"),
    QuoteData(text: "당신의 시간은 한정되어 있다. 다른 사람의 삶을 사느라 낭비하지 마라.", author: "스티브 잡스"),
    QuoteData(text: "행복은 습관이다. 그것을 몸에 지니고 다녀라.", author: "허버트 허바드"),
    QuoteData(text: "우리가 두려워해야 할 단 한 가지는 두려움 그 자체다.", author: "프랭클린 루스벨트"),
    QuoteData(text: "꿈을 꿀 수 있다면 그것을 이룰 수도 있다.", author: "월트 디즈니"),
    QuoteData(text: "넘어지는 것이 실패가 아니다. 넘어진 채로 있는 것이 실패다.", author: "메리 피크포드"),
    QuoteData(text: "가장 어두운 밤도 끝나고 태양은 다시 떠오른다.", author: "빅토르 위고"),
    QuoteData(text: "시작하기 위해 위대해질 필요는 없다. 그러나 위대해지기 위해서는 시작해야 한다.", author: "지그 지글러"),
    QuoteData(text: "오늘 할 수 있는 일을 내일로 미루지 마라.", author: "벤자민 프랭클린"),
    QuoteData(text: "나는 내 운명의 주인이며, 내 영혼의 선장이다.", author: "윌리엄 어니스트 헨리"),
    QuoteData(text: "변화하지 않으면 성장할 수 없고, 성장하지 않으면 진정으로 살고 있는 것이 아니다.", author: "지그 지글러"),
    QuoteData(text: "당신이 세상에서 보고 싶은 변화가 있다면, 당신 자신이 그 변화가 되어라.", author: "마하트마 간디"),
    QuoteData(text: "중요한 것은 두려움 없이 질문하는 것이다.", author: "알베르트 아인슈타인"),
    QuoteData(text: "꿈이 없는 사람은 잠을 자도 아무 의미가 없다.", author: "말콤 X"),
    QuoteData(text: "내가 할 수 없다고 말하는 한, 나는 영원히 할 수 없다.", author: "헨리 포드"),
    QuoteData(text: "무언가를 시작하지 않는 것이 가장 큰 실수다.", author: "이나모리 가즈오"),
    QuoteData(text: "고통은 일시적이다. 포기하면 그것이 영원히 남는다.", author: "랜스 암스트롱"),
    QuoteData(text: "오늘 배우지 않으면 내일 가르칠 수 없다.", author: "버락 오바마"),
    QuoteData(text: "삶에서 가장 큰 영광은 결코 넘어지지 않는 것이 아니라 넘어질 때마다 일어나는 것이다.", author: "넬슨 만델라"),
    QuoteData(text: "행복은 목적지가 아니라 여행하는 방식이다.", author: "마거릿 리 런벡"),
    QuoteData(text: "한 권의 책, 한 자루의 펜, 한 명의 아이, 한 명의 교사가 세상을 바꿀 수 있다.", author: "말랄라 유사프자이"),
    QuoteData(text: "자신을 믿어라. 당신의 능력을 믿어라. 겸손하지만 합리적인 자기 신뢰 없이는 성공할 수도 행복할 수도 없다.", author: "노먼 빈센트 필"),
    QuoteData(text: "성공한 사람이 되려 하지 말고 가치 있는 사람이 되려 하라.", author: "알베르트 아인슈타인"),
    QuoteData(text: "나는 실패한 것이 아니다. 단지 효과 없는 방법 1만 가지를 발견한 것이다.", author: "토마스 에디슨"),
    QuoteData(text: "매일 조금씩 나아지는 것이 삶의 목표다.", author: "레오나르도 다 빈치"),
    QuoteData(text: "모든 위대한 꿈은 한 명의 몽상가로부터 시작된다.", author: "해리엇 터브먼"),
    QuoteData(text: "시간은 가장 민주적인 자원이다. 모든 사람에게 하루 24시간이 주어진다.", author: "하비 맥케이"),
    QuoteData(text: "준비가 기회를 만났을 때 행운이 된다.", author: "세네카"),
    QuoteData(text: "지식이 있다면 다른 사람들이 횃불을 켤 수 있도록 도와라.", author: "마거릿 풀러"),
    QuoteData(text: "당신이 생각하는 것이 당신이 된다.", author: "붓다"),
    QuoteData(text: "불가능이란 단어는 바보의 사전에나 있다.", author: "나폴레옹 보나파르트"),
    QuoteData(text: "아는 것으로 충분하지 않다. 적용해야 한다. 원하는 것으로 충분하지 않다. 실행해야 한다.", author: "요한 볼프강 폰 괴테"),
    QuoteData(text: "진정한 발견의 항해는 새로운 땅을 찾는 것이 아니라 새로운 눈으로 보는 것이다.", author: "마르셀 프루스트"),
    QuoteData(text: "삶이 있는 곳에 희망이 있다.", author: "마르쿠스 툴리우스 키케로"),
    QuoteData(text: "하루하루를 인생의 마지막 날처럼 살아라. 그러면 언젠가 분명히 옳은 날이 올 것이다.", author: "스티브 잡스"),
    QuoteData(text: "우리가 두려워하는 어둠 속에 있는 것이 바로 우리가 찾는 빛이다.", author: "마틴 루터 킹 주니어"),
    QuoteData(text: "지혜로운 사람은 기회를 찾지 않고 기회를 만든다.", author: "프랜시스 베이컨"),
    QuoteData(text: "당신이 무언가에 집중할 때, 그것이 당신에게 현실이 된다.", author: "오프라 윈프리"),
    QuoteData(text: "인내는 쓰다. 그러나 그 열매는 달다.", author: "장 자크 루소"),
    QuoteData(text: "삶의 가장 큰 위험은 너무 조심스럽게 사는 것이다.", author: "알프레드 아들러"),
    QuoteData(text: "가장 위대한 영광은 한 번도 실패하지 않는 데 있는 것이 아니라, 실패할 때마다 다시 일어서는 데 있다.", author: "공자"),
    QuoteData(text: "완벽함이란 더 이상 추가할 것이 없을 때가 아니라 더 이상 제거할 것이 없을 때 달성된다.", author: "앙투안 드 생텍쥐페리"),
    QuoteData(text: "먼저 자신을 사랑하라. 그러면 모든 것이 제자리를 찾는다.", author: "루실 볼"),
    QuoteData(text: "지금 어디에 있는지보다 어디로 향하고 있는지가 더 중요하다.", author: "올리버 웬들 홈스"),
    QuoteData(text: "우리는 살면서 많은 패배를 겪을 수도 있지만, 정복당해서는 안 된다.", author: "마야 안젤루"),
    QuoteData(text: "가장 어려운 것은 행동하기로 결정하는 것이다. 나머지는 단순히 끈기의 문제다.", author: "아멜리아 에어하트"),
    QuoteData(text: "자신을 바꾸지 않고 삶이 바뀌기를 기대하는 것은 씨를 뿌리지 않고 수확을 기대하는 것과 같다.", author: "제임스 앨런"),
    QuoteData(text: "배움에는 끝이 없다. 매일 무언가를 배우는 사람이 진정한 현자다.", author: "레오나르도 다 빈치"),
    QuoteData(text: "용기란 두려움이 없는 것이 아니라 두려움보다 더 중요한 무언가가 있다고 판단하는 것이다.", author: "앰브로즈 레드문"),
    QuoteData(text: "기적이란 노력을 기울이지 않고도 이룰 수 있는 것이 아니라, 끊임없는 노력 끝에 찾아오는 것이다.", author: "파블로 피카소"),
    QuoteData(text: "우리가 무엇인지는 우리가 반복적으로 하는 것에 달려 있다. 따라서 탁월함은 행위가 아니라 습관이다.", author: "아리스토텔레스"),
    QuoteData(text: "삶을 두려워하지 마라. 삶이 좋은 것임을 믿어라. 그러면 그 믿음이 사실을 만드는 데 도움이 될 것이다.", author: "윌리엄 제임스"),
    QuoteData(text: "남들이 당신을 믿어주길 기다리지 마라. 먼저 당신 자신을 믿어라.", author: "말리아 슈나이더"),
    QuoteData(text: "목표가 있는 사람은 방향을 잃지 않는다.", author: "얼 나이팅게일"),
    QuoteData(text: "성공은 매일 반복되는 작은 노력들의 합이다.", author: "로버트 콜리어"),
    QuoteData(text: "당신의 태도가 당신의 방향을 결정한다.", author: "짐 론"),
    QuoteData(text: "두려움을 극복하는 유일한 방법은 그것을 직면하는 것이다.", author: "엘리너 루스벨트"),
    QuoteData(text: "오늘 당신이 심는 씨앗이 내일의 그늘을 만든다.", author: "중국 속담"),
    QuoteData(text: "불행을 두려워하지 마라. 불행은 위장된 축복일 수 있다.", author: "마크 트웨인"),
    QuoteData(text: "마음이 준비되면 모든 것이 준비된다.", author: "공자"),
    QuoteData(text: "지금 이 순간 당신이 가진 것으로 할 수 있는 일을 하라.", author: "시어도어 루스벨트"),
    QuoteData(text: "위대함은 태어나는 것이 아니라 선택하는 것이다.", author: "조 패터노"),
    QuoteData(text: "실패는 끝이 아니라 새로운 시작이다.", author: "헨리 포드"),
    QuoteData(text: "산은 움직이지 않지만 인간의 의지는 산도 움직인다.", author: "무하마드 알리"),
    QuoteData(text: "진정한 지식은 자신이 얼마나 모르는지를 아는 것이다.", author: "소크라테스"),
    QuoteData(text: "작은 일에도 최선을 다하라. 큰 기회는 작은 일에서 시작된다.", author: "루크 다더리지"),
    QuoteData(text: "생각하는 대로 살지 않으면 사는 대로 생각하게 된다.", author: "폴 부르제"),
    QuoteData(text: "강물은 결코 강물을 마시지 않는다. 나무는 자신의 열매를 먹지 않는다. 현자는 자신을 위해 살지 않는다.", author: "인도 속담"),
    QuoteData(text: "당신이 원하는 삶을 상상하라. 그런 다음 그것을 현실로 만들어라.", author: "엘리노르 루스벨트"),
    QuoteData(text: "아무것도 하지 않으면 아무것도 변하지 않는다.", author: "토니 로빈스"),
    QuoteData(text: "세상은 고통으로 가득 차 있지만, 동시에 그것을 극복하는 것으로도 가득 차 있다.", author: "헬렌 켈러"),
    QuoteData(text: "나는 오늘보다 더 나은 내일을 위해 존재한다.", author: "마야 안젤루"),
    QuoteData(text: "모든 새벽은 새로운 기회다.", author: "달라이 라마"),
    QuoteData(text: "가장 좋은 복수는 엄청난 성공을 거두는 것이다.", author: "프랭크 시나트라"),
    QuoteData(text: "당신이 가장 두려워하는 것이 당신이 가장 필요한 것일 수 있다.", author: "로빈 샤르마"),
    QuoteData(text: "열정이 없는 곳에 재능도 없다.", author: "에릭 토마스"),
    QuoteData(text: "당신이 집중하는 것이 성장한다.", author: "로이 T. 베넷"),
    QuoteData(text: "지식은 힘이 아니다. 지식을 실행하는 것이 힘이다.", author: "프란시스 베이컨"),
    QuoteData(text: "인생에서 가장 중요한 것은 어디 있느냐가 아니라 어느 방향으로 가고 있느냐다.", author: "올리버 웬들 홈스"),
    QuoteData(text: "위대한 생각은 위대한 행동으로 이어져야 한다.", author: "윌리엄 하즐리트"),
    QuoteData(text: "당신의 최고의 날은 아직 오지 않았다.", author: "조엘 오스틴"),
    QuoteData(text: "한계는 마음속에만 존재한다.", author: "아놀드 슈워제네거"),
    QuoteData(text: "어제의 집착을 버리면 오늘이 더 자유롭다.", author: "달라이 라마"),
    QuoteData(text: "강한 사람은 힘으로 이기고, 지혜로운 사람은 인내로 이긴다.", author: "벤자민 프랭클린"),
    QuoteData(text: "당신이 원하는 것을 요청하라. 사람들이 모르면 도울 수 없다.", author: "마리 포레오"),
    QuoteData(text: "포기란 무엇인지 아는 사람만이 성공의 의미를 안다.", author: "빈스 롬바디"),
    QuoteData(text: "성공하는 사람들은 습관적으로 성공을 위한 일을 한다.", author: "브라이언 트레이시"),
    QuoteData(text: "변화는 도전이 아니라 기회다.", author: "넬슨 만델라"),
    QuoteData(text: "당신의 잠재력은 당신의 결단에 달려 있다.", author: "지그 지글러"),
    QuoteData(text: "오늘의 고통이 내일의 강함이 된다.", author: "아놀드 슈워제네거"),
    QuoteData(text: "희망을 잃지 마라. 어두운 터널 끝에는 반드시 빛이 있다.", author: "빅토르 프랭클"),
    QuoteData(text: "삶의 의미는 당신의 재능을 발견하는 것이고, 삶의 목적은 그것을 나누는 것이다.", author: "파블로 피카소"),
    QuoteData(text: "위기는 위장된 기회다.", author: "아인슈타인"),
    QuoteData(text: "도전이란 삶을 흥미롭게 만들고, 그것을 극복하는 것이 삶을 의미 있게 만든다.", author: "조슈아 J. 마린"),
    QuoteData(text: "진정한 용기는 두려움을 느끼지 않는 것이 아니라, 두려움에도 불구하고 행동하는 것이다.", author: "브레네 브라운"),
    QuoteData(text: "당신이 오늘 심는 씨앗이 당신이 내일 수확하는 것이 된다.", author: "제임스 앨런"),
    QuoteData(text: "행동하지 않는 꿈은 그저 꿈일 뿐이다.", author: "조엘 A. 바커"),
    QuoteData(text: "자기 자신을 이기는 것이 가장 위대한 승리다.", author: "플라톤"),
    QuoteData(text: "당신의 에너지는 당신의 관심이 어디에 있느냐에 따라 달라진다.", author: "에크하르트 톨레"),
    QuoteData(text: "성공은 영구적이지 않고, 실패는 치명적이지 않다. 계속하려는 용기가 중요하다.", author: "마이크 디트카"),
    QuoteData(text: "내 삶에서 가장 어두운 순간들이 내가 가장 밝게 빛날 수 있는 순간들이었다.", author: "마틴 루터 킹 주니어"),
    QuoteData(text: "매 순간은 새로운 시작이다.", author: "T.S. 엘리엇"),
    QuoteData(text: "당신이 가진 것에 감사하라. 그러면 더 많은 것을 갖게 될 것이다.", author: "오프라 윈프리"),
    QuoteData(text: "좋은 생각은 행동으로 옮겨지기 전까지는 아무 가치가 없다.", author: "토마스 에디슨"),
    QuoteData(text: "인내와 끈기는 마법의 효과를 낸다. 어려움과 장벽들이 사라진다.", author: "존 퀸시 애덤스"),
    QuoteData(text: "당신이 무언가를 간절히 원한다면, 온 우주가 당신을 도울 것이다.", author: "파울로 코엘료"),
    QuoteData(text: "배움의 가장 좋은 방법은 가르치는 것이다.", author: "센카"),
    QuoteData(text: "자신의 한계를 알고 그것을 뛰어넘으려는 사람만이 성장한다.", author: "브루스 리"),
    QuoteData(text: "두려움이란 우리가 발명한 것 중에서 가장 큰 거짓말이다.", author: "빌 코스비"),
    QuoteData(text: "오늘 당신이 선택한 것들이 내일의 당신을 만든다.", author: "마리아 로빈슨"),
    QuoteData(text: "삶이란 당신에게 일어나는 일이 아니라 당신이 그것에 어떻게 반응하느냐다.", author: "알버트 메라비안"),
    QuoteData(text: "모든 전문가는 한때 초보자였다.", author: "헬렌 헤이스"),
    QuoteData(text: "실패하는 것을 두려워하지 마라. 시도하지 않는 것을 두려워하라.", author: "로이 T. 베넷"),
    QuoteData(text: "꿈을 향해 나아가라. 그리고 그 과정에서 성장하는 자신을 발견하라.", author: "헨리 데이비드 소로"),
    QuoteData(text: "당신이 믿는 것이 당신이 경험하는 현실을 만든다.", author: "오프라 윈프리"),
    QuoteData(text: "하루를 시작하는 방법이 그날의 나머지를 결정한다.", author: "로빈 샤르마"),
    QuoteData(text: "행동이 없는 비전은 꿈에 불과하다. 비전이 없는 행동은 단순한 시간 낭비다.", author: "조엘 A. 바커"),
    QuoteData(text: "당신은 당신이 반복적으로 하는 것의 결과물이다.", author: "아리스토텔레스"),
    QuoteData(text: "작은 진전은 여전히 진전이다.", author: "성 프란체스코"),
    QuoteData(text: "인생은 짧다. 하고 싶은 일을 하라.", author: "스티브 잡스"),
    QuoteData(text: "당신이 변화를 원한다면, 당신이 그 변화의 첫 번째 걸음이 되어야 한다.", author: "마하트마 간디"),
    QuoteData(text: "성공의 비밀은 시작하는 것이다.", author: "마크 트웨인"),
    QuoteData(text: "인내는 쓰지만 그 열매는 달다.", author: "장자크 루소"),
    QuoteData(text: "과거를 바꿀 수는 없지만, 미래는 선택할 수 있다.", author: "브라이언 트레이시"),
    QuoteData(text: "생각이 바뀌면 행동이 바뀌고, 행동이 바뀌면 습관이 바뀌고, 습관이 바뀌면 성격이 바뀌고, 성격이 바뀌면 운명이 바뀐다.", author: "윌리엄 제임스"),
    QuoteData(text: "남들이 하는 말에 귀 기울이되, 자신의 목소리를 잃지 마라.", author: "스티브 잡스"),
    QuoteData(text: "당신의 한계는 당신의 상상력만큼 넓다.", author: "아놀드 슈워제네거"),
    QuoteData(text: "희망은 깨어 있을 때 꾸는 꿈이다.", author: "아리스토텔레스"),
    QuoteData(text: "조용히 포기하는 것이 가장 큰 실패다.", author: "밀드레드 맥클로드"),
    QuoteData(text: "당신이 있는 곳에서, 당신이 가진 것으로, 당신이 할 수 있는 것을 하라.", author: "시어도어 루스벨트"),
    QuoteData(text: "위대한 성취는 위대한 위험으로부터 나온다.", author: "헤로도토스"),
    QuoteData(text: "두려움에 맞서라. 그 너머에 자유가 있다.", author: "마리아 로빈슨"),
    QuoteData(text: "매 순간 최선을 다하라. 그것이 당신의 미래를 만든다.", author: "오프라 윈프리"),
    QuoteData(text: "진정한 지혜는 자신의 무지를 아는 것에서 시작된다.", author: "소크라테스"),
    QuoteData(text: "삶을 앞으로 살아야 하지만, 이해는 뒤를 돌아봐야 한다.", author: "쇠렌 키르케고르"),
    QuoteData(text: "꿈을 추구하는 용기를 가져라.", author: "월트 디즈니"),
    QuoteData(text: "성공한 사람들은 포기하지 않는 사람들이다.", author: "빈스 롬바디"),
    QuoteData(text: "당신이 무엇을 원하는지 알고, 그것을 위해 최선을 다하라.", author: "브라이언 트레이시"),
    QuoteData(text: "행복을 찾지 말라. 먼저 자신을 찾아라.", author: "알버트 카뮈"),
    QuoteData(text: "최고의 보복은 엄청난 성공이다.", author: "프랭크 시나트라"),
    QuoteData(text: "당신이 무엇을 생각하느냐가 당신이 누구인지를 결정한다.", author: "마르쿠스 아우렐리우스"),
    QuoteData(text: "결단력이 있는 사람은 반드시 기회를 찾는다.", author: "아브라함 링컨"),
    QuoteData(text: "자신을 극복하는 것이 가장 위대한 성취다.", author: "아리스토텔레스"),
    QuoteData(text: "내일은 어제 행동하지 않은 사람들에게 주어지는 선물이 아니다.", author: "토니 로빈스"),
    QuoteData(text: "꿈이 없는 사람에게 영감을 줄 수 없다.", author: "코레타 스콧 킹"),
    QuoteData(text: "세상이 당신에게 주는 것이 아니라, 당신이 세상에 주는 것이 중요하다.", author: "마야 안젤루"),
    QuoteData(text: "지금 이 순간, 당신이 가진 가장 큰 힘은 선택할 수 있는 능력이다.", author: "로이 T. 베넷"),
    QuoteData(text: "두렵더라도 그냥 하라.", author: "수전 제퍼스"),
    QuoteData(text: "자신의 가치를 알고 그에 맞게 행동하라.", author: "오프라 윈프리"),
    QuoteData(text: "열정 없이는 아무것도 위대한 것이 이루어지지 않는다.", author: "게오르크 빌헬름 프리드리히 헤겔"),
    QuoteData(text: "당신이 되고 싶은 사람이 되는 것은 결코 너무 늦지 않았다.", author: "조지 엘리엇"),
    QuoteData(text: "배움의 끝은 삶의 끝이다.", author: "로마 속담"),
    QuoteData(text: "인생에서 진정으로 중요한 것은 두려워하지 않는 것이다.", author: "헬렌 켈러"),
    QuoteData(text: "당신의 현실은 당신의 생각이 만든다.", author: "마르쿠스 아우렐리우스"),
    QuoteData(text: "지금 시작하라. 완벽한 때는 결코 오지 않는다.", author: "나폴레옹 힐"),
    QuoteData(text: "작은 일에서의 충실함이 큰 일에서의 충실함을 만든다.", author: "루크 복음서"),
    QuoteData(text: "성공의 가장 확실한 방법은 한 번 더 시도하는 것이다.", author: "토마스 에디슨"),
    QuoteData(text: "당신의 인생 이야기를 자신이 쓰라. 남이 쓰게 내버려두지 마라.", author: "엘리자베스 워렌"),
    QuoteData(text: "현재에 집중하라. 그것이 유일한 현실이다.", author: "에크하르트 톨레"),
    QuoteData(text: "당신이 오늘 하는 선택들이 내일을 만든다.", author: "로이 T. 베넷"),
    QuoteData(text: "용기란 두려움을 느끼지 않는 것이 아니라, 두려움을 정복하는 것이다.", author: "넬슨 만델라"),
    QuoteData(text: "시련이 클수록 영광도 크다.", author: "에픽테토스"),
    QuoteData(text: "더 높이 올라갈수록 더 넓은 세상을 보게 된다.", author: "닐 암스트롱"),
    QuoteData(text: "당신이 믿는 만큼 성취할 수 있다.", author: "오프라 윈프리"),
    QuoteData(text: "태양이 지지 않는 제국처럼, 학습도 멈추지 마라.", author: "벤자민 프랭클린"),
    QuoteData(text: "세상에서 가장 강한 사람은 자신을 통제하는 사람이다.", author: "도스토예프스키"),
    QuoteData(text: "기회는 준비된 마음을 선호한다.", author: "루이 파스퇴르"),
    QuoteData(text: "모든 전문가는 초보자였을 때가 있었다.", author: "헬렌 헤이스"),
    QuoteData(text: "역경은 인간의 진정한 강함을 시험하는 시금석이다.", author: "세네카"),
    QuoteData(text: "당신이 해야 할 가장 어려운 일은 시작하는 것이다.", author: "마크 트웨인"),
    QuoteData(text: "행복이란 우리가 가진 것을 얼마나 사랑하느냐에 달려 있다.", author: "브레네 브라운"),
    QuoteData(text: "자신을 아는 것이 지혜의 시작이다.", author: "아리스토텔레스"),
    QuoteData(text: "굳건한 믿음은 산도 옮긴다.", author: "성경"),
    QuoteData(text: "당신의 에너지를 진짜 중요한 것에 쏟아라.", author: "스티브 잡스"),
    QuoteData(text: "오늘을 살아라. 내일은 또 내일의 태양이 뜬다.", author: "마가렛 미첼"),
    QuoteData(text: "당신이 포기하지 않는 한, 실패는 없다.", author: "알베르트 슈바이처"),
    QuoteData(text: "비바람 없이는 무지개도 없다.", author: "돌리 파튼"),
    QuoteData(text: "삶에서 가장 중요한 교훈은 역경에서 배운다.", author: "루시아 알라이나"),
    QuoteData(text: "진정한 행복은 무언가를 향해 나아갈 때 찾아온다.", author: "빅터 프랭클"),
    QuoteData(text: "의지가 있는 곳에 길이 있다.", author: "벤자민 프랭클린"),
    QuoteData(text: "오늘보다 나은 내일을 위해 행동하라.", author: "달라이 라마"),
    QuoteData(text: "삶의 가장 위대한 모험은 두려움 없이 자신으로 사는 것이다.", author: "에픽테토스"),
    QuoteData(text: "지금 여기에 온전히 존재하라.", author: "람 다스"),
    QuoteData(text: "당신의 최악의 날도 누군가에게는 최고의 날보다 낫다.", author: "레이 브래드버리"),
    QuoteData(text: "자신에게 정직해야만 성장할 수 있다.", author: "오프라 윈프리"),
    QuoteData(text: "성공의 반은 그냥 나타나는 것이다.", author: "우디 알렌"),
    QuoteData(text: "두려움은 창의성의 적이다.", author: "스티브 잡스"),
    QuoteData(text: "한 발짝 앞으로 나아가면 두 발짝 앞이 보인다.", author: "마틴 루터 킹"),
    QuoteData(text: "자신의 생각을 통제하면 삶을 통제할 수 있다.", author: "마르쿠스 아우렐리우스"),
    QuoteData(text: "배움은 삶의 가장 큰 기쁨 중 하나다.", author: "에런 허프만"),
    QuoteData(text: "당신이 무엇을 생각하느냐가 당신의 삶을 만든다.", author: "마르쿠스 아우렐리우스"),
    QuoteData(text: "오늘 하루를 선물로 받아들여라.", author: "달라이 라마"),
    QuoteData(text: "진정한 강인함은 부드러움에서 나온다.", author: "라오쯔"),
    QuoteData(text: "나는 천천히 걷지만, 뒤로는 가지 않는다.", author: "아브라함 링컨"),
    QuoteData(text: "행복의 비결은 자신이 가진 것에 감사하는 것이다.", author: "윌리엄 새클리"),
    QuoteData(text: "당신이 할 수 있다고 믿으면 이미 반은 한 것이다.", author: "시어도어 루스벨트"),
    QuoteData(text: "역경은 영혼을 시험하는 위대한 교사다.", author: "토마스 페인"),
    QuoteData(text: "모든 것은 결국 좋아질 것이다. 좋지 않다면 아직 끝이 아니다.", author: "존 레논"),
    QuoteData(text: "삶은 우리가 예상하는 것이 아니라 우리가 선택하는 것으로 만들어진다.", author: "에이미 아담스"),
    QuoteData(text: "당신의 꿈을 포기하지 마라. 꿈이 없으면 아무것도 없다.", author: "토마스 에디슨"),
    QuoteData(text: "지금 이 순간이 가장 중요하다. 지금을 충실히 살아라.", author: "붓다"),
    QuoteData(text: "성공은 준비와 기회가 만나는 지점이다.", author: "오프라 윈프리"),
    QuoteData(text: "어떤 상황에서도 희망을 잃지 않는 것이 가장 큰 용기다.", author: "빅터 프랭클"),
    QuoteData(text: "남들보다 더 많이 생각하고, 더 많이 공부하며, 더 많이 노력하라.", author: "빌 게이츠"),
    QuoteData(text: "지금 이 순간 당신이 하는 선택이 당신의 운명을 결정한다.", author: "토니 로빈스"),
    QuoteData(text: "세상에서 가장 용감한 행동은 자신을 있는 그대로 사랑하는 것이다.", author: "브레네 브라운"),
    QuoteData(text: "목표는 꿈에 날짜를 붙인 것이다.", author: "다이아나 슈어프"),
    QuoteData(text: "자신의 가능성을 의심하지 마라.", author: "파울로 코엘료"),
    QuoteData(text: "우리가 바꿀 수 없는 것을 받아들이고, 바꿀 수 있는 것에 집중하라.", author: "라인홀트 니부어"),
    QuoteData(text: "지식은 나눌수록 커진다.", author: "마리아 퀴리"),
    QuoteData(text: "위험을 감수하지 않으면 위험을 감수하는 것이다.", author: "에리카 종"),
    QuoteData(text: "미래는 자신의 꿈의 아름다움을 믿는 사람들의 것이다.", author: "엘리너 루스벨트"),
    QuoteData(text: "삶이란 무엇을 하느냐가 아니라 어떻게 하느냐로 결정된다.", author: "조지 엘리엇"),
    QuoteData(text: "인생에서 가장 중요한 것은 결과가 아니라 과정이다.", author: "랄프 왈도 에머슨"),
    QuoteData(text: "당신의 삶을 가장 아름답게 만드는 것은 작은 기쁨들이다.", author: "파블로 피카소"),
    QuoteData(text: "가장 위대한 발견은 인간이 자신의 태도를 바꿈으로써 삶을 바꿀 수 있다는 것이다.", author: "윌리엄 제임스"),
    QuoteData(text: "당신의 성격이 당신의 운명이다.", author: "헤라클레이토스"),
    QuoteData(text: "언제나 더 나아질 수 있다. 그것이 삶의 가장 흥미로운 점이다.", author: "사라 블레이클리"),
    QuoteData(text: "나는 내가 선택한 삶을 살고 있는가?", author: "소크라테스"),
    QuoteData(text: "삶은 모험이거나 아무것도 아니다.", author: "헬렌 켈러"),
    QuoteData(text: "변화란 어렵지 않다. 단지 낯선 것이다.", author: "줄리아 캐머런"),
    QuoteData(text: "세상을 바꾸는 가장 좋은 방법은 먼저 자기 자신을 바꾸는 것이다.", author: "레오 톨스토이"),
    QuoteData(text: "성장은 결코 편안함에서 오지 않는다.", author: "로이 T. 베넷"),
    QuoteData(text: "오늘의 도전이 내일의 기회가 된다.", author: "오바마"),
    QuoteData(text: "자신을 이해하는 것이 다른 모든 것의 기초다.", author: "아리스토텔레스"),
    QuoteData(text: "나는 나의 실수에서 배운다. 그것이 나를 더 강하게 만든다.", author: "마이클 조던"),
    QuoteData(text: "꿈을 향해 나아가는 용기가 바로 기적을 만든다.", author: "코엘료"),
    QuoteData(text: "자신의 이야기를 써라. 남의 이야기에 조연이 되지 마라.", author: "마야 안젤루"),
    QuoteData(text: "오늘 할 일을 내일로 미루면, 내일 당신은 두 배로 일해야 한다.", author: "벤자민 프랭클린"),
    QuoteData(text: "당신이 원하는 것이 무엇인지 알아야 그것을 얻을 수 있다.", author: "짐 론"),
    QuoteData(text: "가장 큰 위험은 위험을 감수하지 않는 것이다.", author: "마크 저커버그"),
    QuoteData(text: "어떤 것도 두 번 경험하지 않는다. 그래서 삶은 소중하다.", author: "비스와바 쉼보르스카"),
    QuoteData(text: "당신이 원하는 삶을 위해 작은 용기를 내어라.", author: "엘리노어 루스벨트"),
    QuoteData(text: "참된 용기는 두려움이 없는 것이 아니라 두려움을 통해 빛을 발하는 것이다.", author: "어니스트 헤밍웨이"),
    QuoteData(text: "당신이 감사하지 않으면, 충분히 가져도 부족하다고 느낄 것이다.", author: "오프라 윈프리"),
    QuoteData(text: "성공을 원한다면 실패를 두려워하지 마라.", author: "마이클 조던"),
    QuoteData(text: "자신을 사랑하는 것이 진정한 행복의 시작이다.", author: "레오 부스카글리아"),
    QuoteData(text: "당신은 당신이 생각하는 것보다 훨씬 더 강하다.", author: "A. A. 밀른"),
    QuoteData(text: "성장하기 위해서는 불편함을 감수해야 한다.", author: "짐 론"),
    QuoteData(text: "지금 당신이 있는 곳에서, 지금 당신이 할 수 있는 것을 하라.", author: "아서 애쉬"),
    QuoteData(text: "행복은 이미 당신 안에 있다. 그것을 찾아라.", author: "마르쿠스 아우렐리우스"),
    QuoteData(text: "나의 삶은 나의 가장 위대한 예술작품이다.", author: "오스카 와일드"),
    QuoteData(text: "꿈꾸는 자만이 세상을 바꿀 수 있다.", author: "스티브 잡스"),
    QuoteData(text: "당신이 집중하는 것에 에너지가 흘러들어간다.", author: "토니 로빈스"),
    QuoteData(text: "살아있다는 것은 성장하고 있다는 것이다.", author: "앙리 베르그송"),
    QuoteData(text: "두려움은 실패가 아니라 시도하지 않음에서 온다.", author: "캐서린 버넷"),
    QuoteData(text: "어제는 역사고, 내일은 미스터리며, 오늘은 선물이다. 그래서 현재를 Present(선물)라고 한다.", author: "빌 킨"),
    QuoteData(text: "자신의 가능성을 믿는 것이 성공의 첫 번째 단계다.", author: "나폴레옹 힐"),
    QuoteData(text: "결국 중요한 것은 당신이 얼마나 오래 살았느냐가 아니라 어떻게 살았느냐다.", author: "아브라함 링컨"),
    QuoteData(text: "우리는 우리가 반복적으로 하는 행동의 산물이다.", author: "아리스토텔레스"),
    QuoteData(text: "오늘의 땀이 내일의 성공이다.", author: "무하마드 알리"),
    QuoteData(text: "당신이 가장 두려워하는 것이 당신이 가장 필요로 하는 것일 수 있다.", author: "칼 융"),
    QuoteData(text: "어디를 가든, 온 마음을 다해 가라.", author: "공자"),
    QuoteData(text: "당신의 꿈은 당신만이 실현할 수 있다.", author: "랄프 왈도 에머슨"),
    QuoteData(text: "삶에서 가장 어려운 것은 자신을 발견하는 것이다.", author: "니체"),
    QuoteData(text: "선택은 당신의 것이다. 삶을 이끌어나가거나 끌려다니거나.", author: "앤서니 로빈스"),
    QuoteData(text: "당신의 행복을 다른 사람에게 의존하지 마라.", author: "달라이 라마"),
    QuoteData(text: "오늘 당신이 배운 것이 내일 당신을 더 낫게 만든다.", author: "벤자민 프랭클린"),
    QuoteData(text: "자신의 약점을 아는 것이 강함의 시작이다.", author: "소크라테스"),
    QuoteData(text: "당신이 꿈꾸는 것을 실현하기 위해 당신은 무엇을 하고 있는가?", author: "레오나르도 디카프리오"),
    QuoteData(text: "가장 행복한 사람은 가장 많이 가진 사람이 아니라 가장 적게 필요로 하는 사람이다.", author: "소크라테스"),
    QuoteData(text: "인생의 가치는 길이가 아니라 깊이에 있다.", author: "랄프 왈도 에머슨"),
    QuoteData(text: "당신이 생각할 수 있다면, 당신은 그것을 할 수 있다.", author: "오디아 파이퍼"),
    QuoteData(text: "진정한 배움은 삶을 통해 이루어진다.", author: "존 듀이"),
    QuoteData(text: "자신을 사랑하지 않고 다른 사람을 사랑할 수 없다.", author: "루시 리우"),
    QuoteData(text: "모든 위대한 것은 단순하다.", author: "레오 톨스토이"),
    QuoteData(text: "당신의 실수를 인정하고 그로부터 배워라.", author: "워런 버핏"),
    QuoteData(text: "기다리지 마라. 완벽한 시간은 결코 오지 않는다.", author: "나폴레옹 힐"),
    QuoteData(text: "삶은 우리가 얼마나 오래 숨 쉬느냐가 아니라 우리가 얼마나 많이 감동받느냐에 달려 있다.", author: "마야 안젤루"),
    QuoteData(text: "두려움을 느끼는 것은 괜찮다. 두려움에 의해 멈추지 않는 것이 중요하다.", author: "브레네 브라운"),
    QuoteData(text: "당신이 이루고 싶은 것을 명확하게 정의하라.", author: "나폴레옹 힐"),
    QuoteData(text: "지금 이 순간을 충실히 살아라. 과거도 미래도 아닌 지금.", author: "에크하르트 톨레"),
    QuoteData(text: "당신이 가진 것에 집중하라. 없는 것에 집중하지 마라.", author: "오프라 윈프리"),
    QuoteData(text: "모든 날이 좋지는 않지만, 모든 날에는 좋은 것이 있다.", author: "앨리스 모스 얼"),
    QuoteData(text: "당신이 세상에 무엇을 줄 수 있는지 생각하라.", author: "마하트마 간디"),
    QuoteData(text: "자신의 꿈을 실현하기 위한 가장 좋은 시간은 지금이다.", author: "랄프 왈도 에머슨"),
    QuoteData(text: "성공의 가장 큰 적은 실패가 아니라 포기다.", author: "로이 T. 베넷"),
    QuoteData(text: "삶에서 무언가를 이루려면 먼저 그것을 상상해야 한다.", author: "가브리엘 가르시아 마르케스"),
    QuoteData(text: "오늘이 아니면 언제인가? 지금 당장 시작하라.", author: "짐 론"),
    QuoteData(text: "당신의 생각이 바뀌면 세상이 바뀐다.", author: "마르쿠스 아우렐리우스"),
    QuoteData(text: "어려움은 당신을 더 강하게 만든다.", author: "프리드리히 니체"),
    QuoteData(text: "꿈을 이루기 위한 가장 좋은 방법은 실행하는 것이다.", author: "월트 디즈니"),
    QuoteData(text: "진정한 자유는 자신의 마음을 통제하는 것에서 온다.", author: "마르쿠스 아우렐리우스"),
    QuoteData(text: "도움을 요청하는 것도 용기다.", author: "브레네 브라운"),
    QuoteData(text: "빛이 되고 싶다면, 먼저 어둠을 두려워하지 마라.", author: "마틴 루터 킹"),
    QuoteData(text: "당신의 마음속에 있는 것이 당신의 삶을 만든다.", author: "랄프 왈도 에머슨"),
    QuoteData(text: "삶에서 가장 귀한 것은 자기 자신을 발견하는 여정이다.", author: "조셉 캠벨"),
    QuoteData(text: "위대한 것을 하려고 하지 마라. 작은 일을 위대하게 하라.", author: "나폴레옹 보나파르트"),
    QuoteData(text: "당신이 할 수 없다고 생각하는 것이 당신을 제한한다.", author: "헨리 포드"),
    QuoteData(text: "지금이 바로 당신이 원하는 삶을 시작할 때다.", author: "오프라 윈프리"),
    QuoteData(text: "인생의 가장 위험한 것은 너무 안전한 길을 가는 것이다.", author: "파울로 코엘료"),
    QuoteData(text: "삶의 목적은 단순히 생존하는 것이 아니라 번영하는 것이다.", author: "마야 안젤루"),
    QuoteData(text: "당신이 원하는 것은 당신이 그것을 원할 때부터 이미 시작된다.", author: "나폴레옹 힐"),
    QuoteData(text: "인내는 모든 슬픔을 치유한다.", author: "공자"),
    QuoteData(text: "자신의 내면에 귀를 기울여라.", author: "스티브 잡스"),
    QuoteData(text: "사랑은 세상을 움직이는 힘이다.", author: "단테 알리기에리"),
    QuoteData(text: "지금 이 순간의 선택이 미래를 만든다.", author: "조 디스펜자"),
    QuoteData(text: "당신이 두려워하는 것을 직면하면, 두려움은 사라진다.", author: "쿠엔틴 타란티노"),
    QuoteData(text: "진정한 실패는 포기하는 것이다.", author: "빈스 롬바디"),
    QuoteData(text: "삶은 배움의 연속이다. 그것을 즐겨라.", author: "클리브 제임스"),
    QuoteData(text: "당신의 잠재력은 무한하다. 한계는 당신의 마음속에만 있다.", author: "토니 로빈스"),
    QuoteData(text: "오늘의 나는 어제의 내가 만든 것이고, 내일의 나는 오늘의 내가 만들 것이다.", author: "갈릴레오 갈릴레이"),
    QuoteData(text: "용기란 불확실성에도 불구하고 앞으로 나아가는 것이다.", author: "에릭 홉스봄"),
    QuoteData(text: "자신을 믿는 것이 성공의 비결이다.", author: "랄프 왈도 에머슨"),
    QuoteData(text: "감사하는 마음이 행복의 문을 연다.", author: "멜로디 비티"),
    QuoteData(text: "당신이 존재하는 것만으로 세상은 더 나은 곳이 된다.", author: "A. A. 밀른"),
    QuoteData(text: "최선을 다한 후에는 결과를 받아들여라.", author: "달라이 라마"),
    QuoteData(text: "삶에는 두 가지 선택이 있다. 있는 그대로 받아들이거나, 아니면 바꾸는 것이다.", author: "데이비스"),
    QuoteData(text: "당신이 오늘 하는 일이 모레의 당신을 결정한다.", author: "마야 안젤루"),
    QuoteData(text: "자신의 목소리를 찾아라. 그것이 당신의 가장 큰 선물이다.", author: "오프라 윈프리"),
    QuoteData(text: "진정한 사랑은 자신을 잃지 않으면서 상대를 사랑하는 것이다.", author: "에리히 프롬"),
    QuoteData(text: "위대한 성공은 많은 작은 실패들 위에 세워진다.", author: "토마스 에디슨"),
    QuoteData(text: "내 가장 큰 위업은 실패한 후에도 포기하지 않은 것이다.", author: "마거릿 대처"),
    QuoteData(text: "진정한 용기는 자신이 두렵다는 것을 인정하고도 앞으로 나아가는 것이다.", author: "스크린 클린"),
    QuoteData(text: "오늘 당신이 하는 것이 내일 당신이 될 사람을 만든다.", author: "해나 아렌트"),
    QuoteData(text: "삶에서 가장 중요한 것은 방향이다. 속도가 아니라.", author: "오리슨 스웻 마든"),
    QuoteData(text: "당신의 현재 상황은 당신의 미래를 결정하지 않는다.", author: "조엘 오스틴"),
    QuoteData(text: "용감하게 사는 것이 오래 사는 것보다 낫다.", author: "루시 모드 몽고메리"),
    QuoteData(text: "삶이란 우리가 거기에 무엇을 기여하느냐에 의해 정의된다.", author: "에리히 프롬"),
    QuoteData(text: "매 아침 새로운 기회가 당신에게 주어진다.", author: "달라이 라마"),
    QuoteData(text: "자신을 알고, 자신을 사랑하며, 자신을 향상시켜라.", author: "아리스토텔레스"),
    QuoteData(text: "행복은 얻는 것이 아니라 만들어 가는 것이다.", author: "소크라테스"),
    QuoteData(text: "우리의 가장 큰 영광은 넘어지지 않는 것이 아니라 매번 일어서는 것이다.", author: "레이 레예스"),
    QuoteData(text: "당신이 오늘 내리는 결정이 당신의 내일을 만든다.", author: "어니스트 헤밍웨이"),
    QuoteData(text: "기회는 기다리는 것이 아니라 만드는 것이다.", author: "피카소"),
    QuoteData(text: "진정한 변화는 내면에서부터 시작된다.", author: "마하트마 간디"),
    QuoteData(text: "당신이 무엇을 이루고 싶다면, 그것을 위해 모든 것을 바쳐라.", author: "무하마드 알리"),
    QuoteData(text: "삶은 스스로 이해하지 않으면 이해되지 않는다.", author: "쇠렌 키르케고르"),
    QuoteData(text: "당신의 삶에서 가장 중요한 것을 먼저 하라.", author: "스티브 코비"),
    QuoteData(text: "어려움을 통해 우리는 더 강해진다.", author: "에픽테토스"),
    QuoteData(text: "삶의 진정한 목적은 자신의 잠재력을 실현하는 것이다.", author: "에이브러햄 매슬로"),
    QuoteData(text: "당신의 꿈을 크게 꿔라. 그리고 그것을 위해 노력하라.", author: "노먼 빈센트 필"),
    QuoteData(text: "지금 충분히 행복하지 않다면, 더 갖게 되어도 행복하지 않을 것이다.", author: "아리스토텔레스"),
    QuoteData(text: "당신이 두려움을 극복할 때, 자유를 얻는다.", author: "짐 캐리"),
    QuoteData(text: "삶의 아름다움은 매 순간에 있다.", author: "마르쿠스 아우렐리우스"),
    QuoteData(text: "성공은 행복의 열쇠가 아니다. 행복이 성공의 열쇠다.", author: "알버트 슈바이처"),
    QuoteData(text: "자신의 이야기를 쓸 수 있는 사람은 자신뿐이다.", author: "조앤 K. 롤링"),
    QuoteData(text: "진정한 위대함은 겸손에서 나온다.", author: "공자"),
    QuoteData(text: "오늘을 충실히 살아야 내일이 풍요롭다.", author: "벤자민 프랭클린"),
    QuoteData(text: "당신의 가능성은 당신의 믿음만큼 크다.", author: "나폴레옹 힐"),
    QuoteData(text: "삶에서 가장 아름다운 순간은 자신을 발견하는 순간이다.", author: "파울로 코엘료"),
    QuoteData(text: "행복은 삶의 의미이며 목적이고, 인간 존재의 전체 목표이자 목적이다.", author: "아리스토텔레스"),
    QuoteData(text: "당신이 배운 것을 실천하라. 그것이 진정한 배움이다.", author: "요한 볼프강 폰 괴테"),
    QuoteData(text: "오늘의 땀이 내일의 빛이 된다.", author: "린다 해이든"),
    QuoteData(text: "진정으로 살기 위해서는 죽음도 두려워하지 않아야 한다.", author: "소크라테스"),
    QuoteData(text: "자신을 가장 잘 아는 것이 가장 큰 지혜다.", author: "아이작 뉴턴"),
    QuoteData(text: "삶에서 무엇을 원하는지 모른다면, 삶이 당신을 어디로 데려갈지 모른다.", author: "존 레논"),
    QuoteData(text: "당신이 믿는 것이 현실이 된다.", author: "헨리 포드"),
    QuoteData(text: "위대한 일은 편안한 곳에서 이루어지지 않는다.", author: "닐 암스트롱"),
    QuoteData(text: "매 순간 최선을 다하는 것이 최고의 전략이다.", author: "마이클 조던"),
    QuoteData(text: "삶의 가장 큰 선물은 자기 자신을 발견하는 여정이다.", author: "조셉 캠벨"),
    QuoteData(text: "당신의 행복은 당신의 책임이다.", author: "토니 로빈스"),
    QuoteData(text: "지혜는 지식이 아니라 경험에서 온다.", author: "헤르만 헤세"),
    QuoteData(text: "어둠이 깊을수록 별이 더 밝게 빛난다.", author: "찰스 A. 비어드"),
    QuoteData(text: "삶을 살아갈 가치가 있게 만드는 것은 도전이다.", author: "오스카 와일드"),
    QuoteData(text: "당신이 오늘 낸 용기가 내일의 당신을 만든다.", author: "엘리너 루스벨트"),
    QuoteData(text: "성공이란 포기하지 않는 능력이다.", author: "나폴레옹 힐"),
    QuoteData(text: "오늘 당신이 어떻게 사느냐가 당신의 인생을 결정한다.", author: "마르쿠스 아우렐리우스"),
    QuoteData(text: "진정한 부는 내면의 평화에 있다.", author: "달라이 라마"),
    QuoteData(text: "자신의 가치를 아는 사람은 두려움 없이 앞으로 나아간다.", author: "오프라 윈프리"),
    QuoteData(text: "우리는 우리가 믿는 것이 된다.", author: "오프라 윈프리"),
    QuoteData(text: "삶의 가장 어려운 부분은 선택이다.", author: "조지 엘리엇"),
    QuoteData(text: "당신이 가진 것에 집중하면, 당신이 없는 것을 잊게 된다.", author: "알버트 카뮈"),
    QuoteData(text: "진정한 자유는 두려움이 없는 삶이다.", author: "팀 페리스"),
    QuoteData(text: "당신의 삶을 최고의 버전으로 만들어라.", author: "브라이언 트레이시"),
    QuoteData(text: "인생에서 가장 큰 모험은 자신의 꿈을 사는 것이다.", author: "오프라 윈프리"),
    QuoteData(text: "매일의 작은 승리들이 큰 성공을 만든다.", author: "이반 레이만"),
    QuoteData(text: "당신이 원하는 삶을 선택할 자유가 있다는 것을 기억하라.", author: "짐 론"),
    QuoteData(text: "삶의 방식은 삶의 의미를 결정한다.", author: "빅터 프랭클"),
    QuoteData(text: "자신이 좋아하는 일을 하면, 평생 단 하루도 일하지 않을 것이다.", author: "공자"),
    QuoteData(text: "최고의 투자는 자기 자신에 대한 투자다.", author: "워런 버핏"),
    QuoteData(text: "당신이 생각하는 모든 것을 믿지 마라.", author: "조셉 머피"),
    QuoteData(text: "역경을 통해 얻은 지혜가 책에서 얻은 지식보다 깊다.", author: "벤자민 디즈레일리"),
    QuoteData(text: "세상에서 가장 멀리 가는 사람은 포기하지 않는 사람이다.", author: "시어도어 루스벨트"),
    QuoteData(text: "오늘 당신이 내린 선택이 당신을 정의한다.", author: "장 폴 사르트르"),
    QuoteData(text: "꿈이 크면 클수록 당신이 걸어야 할 길도 길다. 하지만 그 여정이 아름답다.", author: "파울로 코엘료"),
    QuoteData(text: "자신에 대한 믿음이 모든 것의 시작이다.", author: "칼 구스타프 융"),
    QuoteData(text: "지금 이 순간을 살아라. 그것이 유일한 진리다.", author: "에크하르트 톨레"),
    QuoteData(text: "당신의 마음이 허락하는 한, 당신의 꿈은 이루어질 수 있다.", author: "로이 T. 베넷"),
    QuoteData(text: "시련이 없으면 성장도 없다.", author: "도스토예프스키"),
    QuoteData(text: "사람은 자신이 생각하는 만큼 성장한다.", author: "랄프 왈도 에머슨"),
    QuoteData(text: "오늘이 당신의 인생에서 가장 젊은 날이다.", author: "알프레드 D. 수자"),
    QuoteData(text: "자신의 직관을 믿어라. 그것이 삶의 나침반이다.", author: "스티브 잡스"),
    QuoteData(text: "행복한 사람은 상황에 관계없이 행복을 찾는 사람이다.", author: "에픽테토스"),
    QuoteData(text: "당신이 무엇을 하든 열정을 다해 하라.", author: "마르틴 루터"),
    QuoteData(text: "삶에서 가장 중요한 것은 사랑이다.", author: "레오 톨스토이"),
    QuoteData(text: "내일을 바꾸고 싶다면 오늘 무언가를 해라.", author: "맨들라 만델라"),
    QuoteData(text: "당신은 이미 당신이 필요한 모든 것을 가지고 있다.", author: "오프라 윈프리"),
    QuoteData(text: "작은 것에서 큰 것을 볼 수 있는 눈이 지혜다.", author: "라오쯔"),
    QuoteData(text: "당신이 포기하고 싶을 때 기억하라, 왜 시작했는지.", author: "크리스 브래드퍼드"),
    QuoteData(text: "좋은 삶이란 두려움 없이 자기 자신으로 사는 것이다.", author: "브레네 브라운"),
    QuoteData(text: "삶의 가장 위대한 선물은 자신의 삶을 사랑하는 것이다.", author: "마야 안젤루"),
    QuoteData(text: "도전 없이 이룬 성공은 의미가 없다.", author: "존 F. 케네디"),
    QuoteData(text: "지금 당신이 있는 곳이 당신이 있어야 할 곳이다.", author: "람 다스"),
    QuoteData(text: "당신이 오늘 하는 작은 것들이 내일의 큰 차이를 만든다.", author: "마야 안젤루"),
    QuoteData(text: "자신을 믿고 나아가라. 당신이 생각하는 것보다 훨씬 더 강하다.", author: "테오도어 루스벨트"),
]

// MARK: - Quote Picker (Dart QuotePicker와 동일한 공식)

private func todayQuote() -> QuoteData {
    let calendar = Calendar.current
    let now = Date()
    let year = calendar.component(.year, from: now)
    // Dart: now.difference(DateTime(now.year, 1, 1)).inDays → 1월 1일 = 0
    let dayOfYear = (calendar.ordinality(of: .day, in: .year, for: now) ?? 1) - 1
    let index = (year * 1000 + dayOfYear) % quotes.count
    return quotes[index]
}

// MARK: - Timeline Provider

struct OnedayProvider: TimelineProvider {
    func placeholder(in context: Context) -> QuoteEntry {
        QuoteEntry(
            date: Date(),
            quoteText: "꿈을 꿀 수 있다면 그것을 이룰 수도 있다.",
            quoteAuthor: "월트 디즈니"
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (QuoteEntry) -> Void) {
        let quote = todayQuote()
        completion(QuoteEntry(date: Date(), quoteText: quote.text, quoteAuthor: quote.author))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuoteEntry>) -> Void) {
        let quote = todayQuote()
        let entry = QuoteEntry(date: Date(), quoteText: quote.text, quoteAuthor: quote.author)

        // 자정에 갱신
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: Date().addingTimeInterval(86400))
        let timeline = Timeline(entries: [entry], policy: .after(midnight))
        completion(timeline)
    }
}

// MARK: - Widget View

private var widgetGradient: LinearGradient {
    LinearGradient(
        colors: [
            Color(red: 0.08, green: 0.08, blue: 0.18),
            Color(red: 0.14, green: 0.12, blue: 0.25),
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct OnedayWidgetEntryView: View {
    var entry: OnedayProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 앱 이름
            Text("ONE DAY")
                .font(.system(size: 9, weight: .light, design: .default))
                .foregroundColor(.white.opacity(0.4))
                .kerning(2.5)

            Spacer()

            // 인용 부호
            Text("❝")
                .font(.system(size: family == .systemSmall ? 18 : 24))
                .foregroundColor(.white.opacity(0.25))
                .padding(.bottom, 4)

            // 명언 텍스트
            Text(entry.quoteText)
                .font(.system(size: family == .systemSmall ? 12 : 14, weight: .light))
                .foregroundColor(.white.opacity(0.88))
                .lineSpacing(4)
                .minimumScaleFactor(0.65)
                .lineLimit(family == .systemSmall ? 5 : 6)

            // 저자
            Text("— \(entry.quoteAuthor)")
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.white.opacity(0.5))
                .padding(.top, 6)
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

// MARK: - Widget Configuration

@main
struct OnedayWidget: Widget {
    let kind: String = "OnedayWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: OnedayProvider()) { entry in
            if #available(iOS 17.0, *) {
                OnedayWidgetEntryView(entry: entry)
                    .containerBackground(for: .widget) {
                        LinearGradient(
                            colors: [
                                Color(red: 0.08, green: 0.08, blue: 0.18),
                                Color(red: 0.14, green: 0.12, blue: 0.25),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
            } else {
                ZStack {
                    widgetGradient
                    OnedayWidgetEntryView(entry: entry)
                }
            }
        }
        .configurationDisplayName("One Day 명언")
        .description("오늘의 유명인 명언을 홈 화면에서 확인하세요.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
