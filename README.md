
# Clean Architecture Journey  

## [Ohcle(Today's Climbing) Applying Clean Architecture - Part 1 (in Korean)](https://velog.io/@catcota/사이드-프로젝트-클린아키텍쳐-적용해보기-1탄)
<details>
    <summary> Posting </summary>
    
### Ohcle(오늘의 클라이밍) 클린아키텍쳐 적용해보기 - 1탄
- 기간 : 2024년 3월 28일- 2024년 4월 1일 
- 목적 : 클린아키텍쳐를 이용한 앱 리팩토링, 클린아키텍쳐 고민해보기
- [프로젝트](https://github.com/ohcle/ohcle-iOS/tree/develop_cleanArchitecture) : 브랜치(develop_cleanarchitecture)
    - develop_ca_DTO
    - develop_ca_entity
    - develop_ca_usecaseAndRepository
- 목차
    - 글을 시작하며
    - 의존성이 도대체 뭐야. 
        - 클린아키텍쳐 - 단방향 의존
            - 왜 단방향으로 의존 하는건데?
            - 의존성 역전 법칙(Dependency Inversion Principle, DIP)이란?
    - 레이어 없어도 잘 작동하는데 왜 굳이 이렇게 많이 나눠야하나?
    - 클린 아키텍쳐의 핵심: 내게 주어진 시간이 많이 없다면?
        - 리팩토링 순서
    - 마무리
    
## 글을 시작하며..
클린아키텍쳐가 무엇이고, 누가 이 개념을 시작했는지 등 이 개념에 대한 설명은 저보다 더 잘 설명하고 있는 문서가 많으므로 이 부분은 생략하려고 해요. 4일이라는 짧은 시간동안 기존 프로젝트를 클린아키텍쳐의 개념을 이용해 리팩토링해보면서 고민한 부분들, 클린아키텍쳐에 대한 이해를 위해 어떻게 학습했는지 등을 공유해 보겠습니다. 

## 의존성이 도대체 뭐야
SwiftUI Clean Architecture 를 검색해서 상단에 나오는 글을 무작정 읽어보았어요. 가장 눈에 띄는 단어는 `의존성` 이였는데요. 

의존성 무엇인가 라고 누가 물어보면 어떻게 설명할 수 있을까 고민되더라구요.

우리가 실생활에서 사용하는 의존이란 단어는 너무나 잘 알고 있는 의미잖아요. 그런데 이게 도대체 클린아키텍쳐를 설명하는 글에서 왜 이렇게 많이 나오는 것인가 하는 궁금즘도 생겼구요. 

우선 저는 이 개념을 이렇게 설명 할 수 있을 것 같아요. 

갓 태어난 애기를 상상해볼께요. 이 아가는 밥 먹는 것도, 화장실 가는 것도, 잠 자는 것도 심지어 트림도 모두 보호자의 도움으로 하게 되죠. 이 아기는 자신을 돌보는 보호자가 없다면 그 무엇도 할 수 없을거에요.

아기는 부모에게 `의존` 하고 있다고 표현할 수 있겠죠?

저는 프로그래밍에서도 마찬가지라고 이해했습니다. 
즉, `객체 A가 객체 B에 의존하고 있다` 는 것은 A는 B없이 동작할 수 없는 형태라는 겁니다. 

아래 코드로 볼까요?
 > 사실 Parent 타입에서도 Baby타입의 속성을 가져야 실제 세계와 유사하겠지만, 잠시 이 생각은 뒤로 제쳐둡시다! 의존성에 초점을 맞춰볼게요.

```swift=
struct Baby {
    let parent: Parent
    let name: String
    let age: UInt
    
    func eat() {
        self.parent.feed()
    }
}

struct Parent {
    //MARK: Properties
    ..
    
    //MARK: Methods
    func feed(){
        //
    }
}
```

Baby 타입은 `parent`를 반드시 가져야하며 이 `parent`가 없다면 존재할 수 없을거에요(인스턴스화 될 수 없다는 의미) 

저의 프로젝트에선 이런 코드예시를 가져올 수 있을것 같아요

```swift=
//MARK: - UseCases 
protocol RefreshClimbingRecordUseCase {
    func fetch(requestValue: ClimbingRecordDate) async -> Result<MonthRecordEntity, Error>
}

final class RefreshMonthClimbingRecordUseCase: RefreshClimbingRecordUseCase {
    private let repository: RecordsRepository
    
    init(repository: RecordsRepository) {
        self.repository = repository
    }
    
    func fetch(requestValue: ClimbingRecordDate) async -> Result<MonthRecordEntity, Error> {
        
        //MARK: Devlivering info for Networking
        let result = await repository.fetch(requestValue: requestValue)
        return result.mapError { $0 as Error }
    }
}
```

### 클린아키텍쳐 - 단방향 의존
클린아키텍쳐에서 `의존`이 많이 언급되는 이유는 그것의 가장 중요한 원칙 중 하나가 바로 각 레이어는 단방향으로 의존한다는 것이기 때문이에요. 

즉 각 레이어는 자신보다 밖에 있는 레이어를 의존해선 안된다는 이야기입니다. 예를 들어 UseCases는 Controllers, Gateways, Presenters 역할을 모르고 있어야한다는 이야기죠.

> 여기서 말하는 `모르고 있다`라는 것은 UseCases 내부에서자신의 레이어 밖에 있는 것들을 properties, method의 매게변수, return 타입 등으로 사용하지 않아야 한다는 이야기 입니다. 

![image](https://hackmd.io/_uploads/B1cJBM_kR.png)
https://daryeou.tistory.com/280

#### 왜 단방향으로 의존 하는건데?
그럼 왜 단방향으로 의존하도록 강조하고 있을까요? 

조금 슬픈 이야기지만, 단방향 의존은 마치 짝사랑 같아요. 사랑을 받고 있는 사람은 짝사랑하는 사람이 누구인지 모르고, 그 사람이 나를 떠나도, 나를 그만 좋아해도 전혀 영향이 없죠. 꼭 이사람 뿐만 아니라 다른 사람이 나를 짝사랑하게 된다고 해도 나의 삶에는 전혀 지장이 없을 거에요. 

단방향 의존도 마찬가지랍니다. UseCases가 변하더라도 Entities는 UseCases가 자신을 짝사랑하고 있는지 알지 못하기 때문에 새로운 UseCasees가 생긴다고 하더라도 그 역할과 동작에는 전혀 문제가 없는 거죠. 


#### 의존성 역전 법칙(Dependency Inversion Principle, DIP)이란?

갑자기 너무 어려운 단어가 나오죠?
이 개념은 SOLID라는 객체 지향 프로그래밍 및 설계의 다섯 가지 기본 원칙중 하나에요. 클린아키텍쳐에선 이 DIP를 이용해 객체간의 결합도를 낮추고 있답니다. (즉 서로가 서로를 의존하는 관계를 줄이도록 하고 있어요)

다시 Baby, Parent 코드를 생각해볼께요. 의존성 역전이라는 것은 쉽게말하면 Parent외에도 특정 조건만 만족한다면 그 누구든 아기의 부모가 될 수 있도록 한다는거에요. 

즉 특정 객체(or 타입, 인스턴스)가 아니라 `특정 조건을 만족`하는 객체를 의존하도록 하여 의존 방향을 역전하는 행위라고 볼 수 있을것 같아요.   

Baby, Parent 코드를 프로토콜을 이용해 의존성을 줄이도록 리팩토링 해볼께요

```swift=
// 1. 특정조건 만들기 : Parentable 프로토콜 타입 내부에 보호자가 될 수 있는 조건을 명시해요. 
protocol Parentable {
    func feed()
    func putSleep()
}


struct Baby {
    // 2. 기존의 Parent가 아닌 Parentable타입으로 변경해요. 
    let parent: Parentable
    let name: String
    let age: UInt
    
    func eat() {
        self.parent.feed()
    }
}

struct Parent: Parentable {
    //MARK: Properties
    ..
    
    //MARK: Methods
    func feed(){
        //
    }
    
    func putSleep() {
        
    }
}


struct GrandParents: Parentable {
    //MARK: Properties
    ..
    
    //MARK: Methods
    func feed(){
        //
    }
    
    func putSleep() {
        //
    }
}

struct Goverment: Parentable {
    //MARK: Properties
    ..
    
    //MARK: Methods
    func feed(){
        //
    }
    
    func putSleep() {
        //
    }
}
```

기존 코드에선 Baby는 무조건 Parent 타입의 인스턴스만 속성으로 가질 수 있었지만, 리팩토링한 구조에선 `GrandParents`, `Goverment` 등 Parentable 프로토콜을 채택한 모든 타입의 인스턴스를 parents로 가질 수 있게 돼요.


### 레이어 없어도 잘 작동하는데 왜 굳이 이렇게 많이 나눠야하나?

하는 의문이 드시나요? 저 또한 클린아키텍쳐를 적용하면서 초반에 이 물음에 명확한 답변을 내리기 어려웠는데요!

Entity로 DTO(Data Transfer Object)를 mapping 하면서 제 나름의 답변을 정리할 수 있었어요.  

#### 기존 코드 
```swift=

//Entity, DTO 역할을 동시에 수행
struct CalenderModel: Decodable, Identifiable,Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CalenderModel,
                   rhs: CalenderModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let `where`: ClimbingLocation?
    let when: String
    let level: Int
    let score: Float
    let picture: [String?]?
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case `where`
        case when
        case level
        case score
        case picture
        case thumbnail
    }
    
    struct ClimbingLocation: Decodable {
        let id: Int
        let name: String
        let address: String
        let latitude: Float
        let longitude: Float
    }
}
```

#### 리팩토링 코드
```swift=
//Entity, DTO 역할을 분리
//
// MARK: - Climbing Data Transfer Object (기존에 CalenderModel이였던 것)
struct ClimbingMonthRecord {
    let list: [ClimbingRecord]
}

struct ClimbingRecord: Decodable {
    let id: Int
    let `where`: ClimbingLocation?
    let date: String
    let level: Int
    let score: Float
    let picture: [String?]?
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case `where`
        case date = "when"
        case level
        case score
        case picture
        case thumbnail
    }
    
    struct ClimbingLocation: Decodable {
        let id: Int
        let name: String
        let address: String
        let latitude: Float
        let longitude: Float
    }
}

// MARK: - Mappings to Domain (실제 사용하는 데이터와 연결, 기존의 DividedWeekData 타입의 모델로 맵핑 필요)
extension ClimbingMonthRecord {
    func transformToDomin() -> MonthRecordEntity {
        return .init(monthRecord: self)
    }
}

```
- 서버에서 받는 데이터와 실제 사용하는 데이터가 다를 수 있다.
- 서버에서 받는 데이터의 타입을 변경해야하는 경우가 있다
- 서버에서 받는 데이터의 타입, 종류가 변경되는 경우 이러한 분리를 통해 쉽게 변경을 반영할 수 있다.
- 실제 사용하는 데이터를 명시적으로 분류할 수 있다. 
- 메소드의 역할이 명확해 지고 이를 통해 테스트 코드를 수월하게 작성할 수 있다. 

제가 내린 답변은 위와 같아요.

여러분은 어떻게 생각하시나요?


### 클린 아키텍쳐의 핵심: 내게 주어진 시간이 많이 없다면?
4일 공부하고나서 감히 핵심이라고 이야기할 순 없겠지만, 제가 봤을 때 가장 중요한 것은 의존성관리(단방향 의존, 의존성 줄이기)와 내게 필요한 적절한 레이어 선택 및 그 레이어 대한 정의라고 생각해요.

그리고 더 중요한건, 레이어의 범위는 절대적이지 않다는것입니다.  
단방향으로 의존하고 있으며 각각의 레이어와 그 경계에 대한 역할과 정의를 내렸다면 클린아키텍쳐를 잘 적용(?)하고 있는 것이라고 생각해요. 

가끔 우리는 우리가 사용하고자하는 디자인패턴, 설계에 더 초점을 맞추고 우리의 모든 서비스내용을 그것에 끼워맞추려고 하는 때가 종종 생기는데요. 내가 왜 이 디자인패턴, 아키텍쳐를 선택했는지 다시 한 번 리마인드 해보는 것도 중요한 것 같다는 생각이 들었답니다. 


#### 리팩토링 순서

클린아키텍쳐를 설명하는 글들을 보면 굉장히 많은 레이어로 구성된 것을 볼 수 있는데요. 

추후 서비스의 규모가 커지는 경우 등을 대비하여 이 레이어를 모두 구현해봐도 좋겠지만 내게 주어진 시간이 없다면 이 중 정말 필요한 레이어만 선택하는 것이 좋을 것 같아요. 

또한 내가 생각하는 레이어의 정의를 명확히 한다면 리팩토링 하면서 도대체 이 역할을 하는 객체는 어떤 레이어에 포함되어야하는거지? 하는 생각으로 고민하는 시간을 확 줄일 수 있으실거에요 (저는 이걸 지금에야 깨달았습니다 ㅜ)

저는 이렇게 리팩토링을 시작했어요.

1. DTO 역할을 하고 있는 타입 찾기 
2. Entity 설계하기
3. DTO를 Entity로 Mapping 하기 
4. UseCases 정의하기 
5. Repository 정의하기 

Entity가 가장 고수준에 있는 레이어이기 때문에 이걸 먼저해야하나 싶은 생각이 들었는데, 저는 네트워킹후 디코딩하는 타입을 그대로 ViewModel이 가지는 data로도 사용하고 있었기 때문에 이에 대한 분리가 먼저 필요하다고 생각했어요. 

저의 경우엔 아래와 같이 레이어를 구성하고 정의내렸어요. 

1. Domain 레이어
- UseCases
    - RefreshClimbingRecordUseCase
2. Data 레이어
- Entity
    - MonthRecordEntity
    - ClimbingRecordDate
- Repository
    - RecordRepository
3. Presentaion 레이어
- 해당 레이어는 구현해야하는 필요성을 아직 찾지 못해서 분리하지 않음. 

4. Infrastructure
    - NetworkService

다른 예제코드 및 프로젝트를 보면 Storage, Presenter 등 다양한 역할의 타입을 구현한 것을 볼 수 있었는데요. 저의 경우 주어진 시간이 짧기도 했고, 앱의 규모가 큰 편이 아니었어요. 

여러분들도 다양한 프로젝트를 살펴보면서 여러분만의 클린아키텍쳐 구조와 레이어를 설계해보는 재미를(?!) 느껴보시길 바랄께요!!


### 마무리
사실 이 클린아키텍쳐를 공부하게 된 가장 큰 이유는 앱의 출시만을 목적으로 진행한 사이드프로젝트가 항상 마음에 찝찝하게 남았기 때문이에요.

변명 같지만(또 사실 생각해보면 변명이기도 하죠) 본업을 하면서 사이드를 하다보니 앱 내부 구조와 디자인 패턴에 대해 집중하는 시간을 가지기 정말 어렵더라구요. 특히 프로젝트 기간이 늘어나면서 저와 팀원들 모두 지치다보니 내부구조는 나중에 생각하고 우선 출시하자!!! 를 목표로 하기도 했구요. 

정말 일부 기능만 클린아키텍쳐의 특징을 적용하여 리팩토링 했지만 앞으로 남은 기능도 리팩토링하는것이 저의 목표에요!

- 남은 리팩토링
    - 메모추가, 메모수정 상황에 따른 UseCase 만들기 
    - Storage 만들고 관련 로직 추가하기
    - Caching 로직 추가하기 
    - Network Infrastructure 통일하기 
    - SwiftUI에 적절한 Presenter
    - ...


위 글에서 개념오류를 발견하시거나 같이 논의해보고 싶은 주제가 있다면 언제든지 환영입니다 :)


긴 글 읽어주셔서 감사합니다. 
</details>

## Ohcle(Today's Climbing) Applying Clean Architecture - Part 1
- Studying Duration: March 28, 2024 - April 1, 2024
- Purpose: Refactoring apps using Clean Architecture, thinking about Clean Architecture
- [Projects Github](https://github.com/ohcle/ohcle-iOS/tree/develop_cleanArchitecture) : develop_cleanarchitecture(branch name)
    - develop_ca_DTO
    - develop_ca_entity
    - develop_ca_usecaseAndRepository
- Table of Contents
    - Foreword
    - What Exactly Are Dependencies?
        - Clean Architecture : Dependencies should only point inwards
            - Why?
            - What is the Dependency Inversion Principle (DIP)?
    - Why Divide into So Many Layers When It Works Fine Without Them?
    - Core of Clean Architecture: What if I Don't Have Much Time?
        - Refactoring Sequence
    - Conclusion

    
## Foreword
Since numerous documents provide a more thorough explanation of what Clean Architecture is and who initiated the concept, I'll skip that part. Instead, I'll share my reflections on refactoring some functionalities of an existing project using the principles of Clean Architecture within a short span of four days. I'll discuss the challenges I faced during this process, as well as how I approached learning about Clean Architecture to enhance my understanding.


## What Exactly Are Dependencies?
I've started reading an article about SwiftUI Clean Architecture that popped up at the top of my search results. The term that stood out the most to me was `dependency`


I found myself pondering how to explain what dependency is when someone asks. We're all familiar with the word dependency in our daily lives. However, I couldn't help but wonder why it appears so frequently in articles discussing Clean Architecture.

So, here's how I think I can explain this concept:

Let's imagine a newborn baby. This little one relies on their caregiver for everything – eating, going to the bathroom, sleeping, and even getting dressed. Without someone to take care of them, the baby wouldn't be able to do anything. In other words, we could say the baby is "**dependent**" on their parents, right?

![](https://velog.velcdn.com/images/catcota/post/018ac4f4-32ca-4787-afdf-e43a6a63a307/image.png)
<figcaption style="text-align:center; font-size:15px; color:#808080; margin-top:40px"> Reference : https://velog.velcdn.com/images/catcota/post/018ac4f4-32ca-4787-afdf-e43a6a63a307/
</figcaption>

</br>

I understood it similarly in programming. That is when we say "object A depends on object B," it means A cannot function without B.

Shall we look at the code below?

> In reality, the Parent type should have Baby type property to closely resemble the real world, but let's set aside that thought for a moment! Let's focus on the dependency.

```swift
struct Baby {
    let parent: Parent
    let name: String
    let age: UInt
    
    func eat() {
        self.parent.feed()
    }
}

struct Parent {
    //MARK: Properties
    ..
    
    //MARK: Methods
    func feed(){
        //
    }
}
```

The `Baby` type must have a 'parent' property and without this 'parent' it would not exist (meaning it cannot be instantiated)

I think I can bring this example of code in my project

```swift
//MARK: - UseCases 
protocol RefreshClimbingRecordUseCase {
    func fetch(requestValue: ClimbingRecordDate) async -> Result<MonthRecordEntity, Error>
}

final class RefreshMonthClimbingRecordUseCase: RefreshClimbingRecordUseCase {
    private let repository: RecordsRepository
    
    init(repository: RecordsRepository) {
        self.repository = repository
    }
    
    func fetch(requestValue: ClimbingRecordDate) async -> Result<MonthRecordEntity, Error> {
        
        //MARK: Devlivering info for Networking
        let result = await repository.fetch(requestValue: requestValue)
        return result.mapError { $0 as Error }
    }
}
```

### Clean Architecture : Dependencies should only point inwards
The reason why "dependency" is frequently mentioned in Clean Architecture is because one of its most crucial principles is that each layer should depend unidirectionally, and inwardly.

In other words, each layer should not depend on the layers outside of itself. For example, UseCases should not be aware of the roles of Controllers, Gateways, or Presenters.

When we say "not be aware of," it means that within the UseCases, we should not utilize object that exist outside of its layeras types of properties, method parameters, return types, etc.

![https://daryeou.tistory.com/280](https://hackmd.io/_uploads/B1cJBM_kR.png)
<figcaption style="text-align:center; font-size:15px; color:#808080; margin-top:40px">
    Reference https://daryeou.tistory.com/280
  </figcaption>

#### Why Dependencies should only point inwards
Then why emphasize unidirectional dependency?

It's a bit of a sad story, but unidirectional dependency is like **unrequited love**. The person receiving love doesn't know who is in love with them, and even if that person leaves or stops loving them, it doesn't affect them at all. Similarly, even if someone else falls in love with them, it doesn't disrupt their life.

Unidirectional dependency works the same way. Even if UseCases change, Entities don't know if UseCases are in love with them, so even if new UseCases emerge, there are no issues with their roles and functionalities.

>Note: The analogy used here is for illustrative purposes and may not perfectly capture all aspects of unidirectional dependency in Clean Architecture.

![](https://velog.velcdn.com/images/catcota/post/24e41fc4-5c8f-41be-9660-000902c0832a/image.png)
<figcaption style="text-align:center; font-size:15px; color:#808080; margin-top:40px">
    Reference : https://bbs.ruliweb.com/community/board/300143/read/60973853
</figcaption>


#### What is the Dependency Inversion Principle (DIP)?

Suddenly, some very complex words, right?

This concept is one of the five basic principles of object-oriented programming and design called SOLID. In Clean Architecture, we use DIP to reduce the coupling between objects. (In other words, we aim to reduce relationships where objects depend on each other.)

Let's reconsider the `Baby`, `Parent` code again. Dependency inversion, in simple terms, means that anyone can be the parent of a baby as long as they meet certain conditions, not just the `Parent`.

So, we can consider dependency inversion as the act of reversing the dependency direction by depending on objects that satisfy certain conditions, rather than on specific objects (or types, instances).

Let's refactor the `Baby`, `Parent` type using protocols to reduce dependencies.

> Note: The SOLID principles stand for Single Responsibility, Open-Closed, Liskov Substitution, Interface Segregation, and Dependency Inversion.


```swift
// 1. Creating Specific Conditions: Specify the conditions under which a type can become a caregiver within the Parentable protocol type.
protocol Parentable {
    func feed()
    func putSleep()
}


struct Baby {
    
// 2. Changing to Parentable type instead of the original `Parent`.    
    let parent: Parentable
    let name: String
    let age: UInt
    
    func eat() {
        self.parent.feed()
    }
}

struct Parent: Parentable {
    //MARK: Properties
    ..
    
    //MARK: Methods
    func feed(){
        //
    }
    
    func putSleep() {
        
    }
}


struct GrandParents: Parentable {
    //MARK: Properties
    ..
    
    //MARK: Methods
    func feed(){
        //
    }
    
    func putSleep() {
        //
    }
}

struct Goverment: Parentable {
    //MARK: Properties
    ..
    
    //MARK: Methods
    func feed(){
        //
    }
    
    func putSleep() {
        //
    }
}
```

In the original code, `Baby` could only have an instance of the `Parent` type as its property. However, in the refactored structure, `Baby` can have instances of any type that adopts the `Parentable` protocol, such as `GrandParents`, `Government`, etc., as its parent.


### Why Divide into So Many Layers When It Works Fine Without Them?

Are you also questioning why we must divide things into so many layers when everything seems to work fine without them? I, too, struggled to come up with a clear answer to this question when applying Clean Architecture.

However, as I began mapping DTO(Data Transfer Objects) to Entities, I was able to organize my answer.

#### Original Code
```swift
//CalenderModel serves as both Entity and DTO roles
struct CalenderModel: Decodable, Identifiable,Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CalenderModel,
                   rhs: CalenderModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let `where`: ClimbingLocation?
    let when: String
    let level: Int
    let score: Float
    let picture: [String?]?
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case `where`
        case when
        case level
        case score
        case picture
        case thumbnail
    }
    
    struct ClimbingLocation: Decodable {
        let id: Int
        let name: String
        let address: String
        let latitude: Float
        let longitude: Float
    }
}
```

#### Refactored Code
```swift
//Separation of Entity and DTO roles
//
// MARK: - Climbing Data Transfer Object 
struct ClimbingMonthRecord {
    let list: [ClimbingRecord]
}

struct ClimbingRecord: Decodable {
    let id: Int
    let `where`: ClimbingLocation?
    let date: String
    let level: Int
    let score: Float
    let picture: [String?]?
    let thumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case `where`
        case date = "when"
        case level
        case score
        case picture
        case thumbnail
    }
    
    struct ClimbingLocation: Decodable {
        let id: Int
        let name: String
        let address: String
        let latitude: Float
        let longitude: Float
    }
}

// MARK: - Mappings to Domain
extension ClimbingMonthRecord {
    func transformToDomin() -> MonthRecordEntity {
        return .init(monthRecord: self)
    }
}
```
- The data received from the server may differ from the data actually used.
- There may be cases where the type of data received from the server needs to be changed.
- By separating the type and nature of the data received from the server, it becomes easier to reflect changes.
- It allows for explicit classification of the data actually used.
- The role of methods becomes clearer, making it easier to write test code.

This is my answer. What do you think?


### Core of Clean Architecture: What if I Don't Have Much Time?
I've only studied just for four days so I can't confidently say it's "**the core**".  But from what I've seen, the most important aspects seem to be **dependency management** (unidirectional dependencies, reducing dependencies) and **selecting the appropriate layers** for my needs, along with defining those layers.

![https://medium.com/@duncan.beeby/the-problem-isnt-choice-237385821a1](https://velog.velcdn.com/images/catcota/post/d6e2dfeb-a479-4d45-8f5b-7443eb05982a/image.png)
<figcaption style="text-align:center; font-size:15px; color:#808080; margin-top:40px">
    Reference : https://medium.com/@duncan.beeby/the-problem-isnt-choice-237385821a1
  </figcaption>

</br>

And what's even more important is that **the scope of layers is not absolute**. Once you've established unidirectional dependencies and defined the roles and boundaries of each layer, I believe you're effectively applying Clean Architecture.

Sometimes, we tend to focus more on the design patterns and architectures we want to use, trying to fit all our services into them. It's important to remind ourselves why we chose these design patterns and architectures in the first place.

#### Refactoring Sequence I Did

When you read articles explaining Clean Architecture, you often see it composed of numerous layers.

While it would be beneficial to implement all these layers in preparation for the potential growth of the service, if time is limited, selecting only the truly necessary layers is advisable.

Also, if you clarify the definition of the layer you think, you will be able to reduce the time spent thinking about which layer should the object that plays this role while refactoring be included


Here's how I started refactoring:

> 1. Identify types serving as DTOs.
> 2. Design Entities.
> 3. Map DTOs to Entities.
> 4. Define UseCases.
> 5. Define Repositories.

As Entity is the highest-level layer, I initially felt inclined to prioritize it. However, I realized that I needed to address the separation of types responsible for networking and decoding first. This is because I was using the same types for both networking and decoding, directly as data for ViewModels.


#### Layers I used
In my case, I've organized the layers as below.

> 1. Domain Layer
- UseCases
    - RefreshClimbingRecordUseCase
2. Data Layer
- Entity
    - MonthRecordEntity
    - ClimbingRecordDate
- Repository
    - RecordRepository
3. Presentaion Layer
- I haven't separated this layer yet because I haven't found the need to implement it.
4. Infrastructure
    - NetworkService

When looking at different example codes and projects, I noticed various types fulfilling roles such as *Storage, Presenter*, and others. However, due to the limited time I had and the relatively small scale of my app, I didn't find it necessary to implement such types.

I encourage you all to explore various projects and derive enjoyment from designing your own Clean Architecture structure and layers!


### Concluding Remarks
The main reason I started studying Clean Architecture is that my side projects, which were initially aimed solely at releasing the app, **always left me feeling uneasy**.

![https://debate.protocommunications.com/frustrated-meme/](https://velog.velcdn.com/images/catcota/post/c25df1ed-dbfe-4aa5-b00b-812ffa709dd7/image.png)
<figcaption style="text-align:center; font-size:15px; color:#808080; margin-top:40px">
    Referece : https://debate.protocommunications.com/frustrated-meme/
  </figcaption>

</br>

It may sound like an excuse, but juggling side projects alongside my main job made it incredibly challenging to dedicate time to focus on app internal structures and design patterns. Especially as project deadlines extended, both my team and I grew weary, often prioritizing "Let's release it!" over considering the internal architecture.

Although I managed to refactor only few features using Clean Architecture principles, my goal moving forward is to refactor the remaining features as well!

- Remaining Refactoring Required Features
    - Create UseCases for adding and editing memos depending on the situation
    - Create Storage object and add related logic
    - Add caching logic
    - Implement network infrastructure
    - Implement suitable Presenter for SwiftUI
    - ...


If you notice any conceptual errors in the above text or have any topics you'd like to discuss together, please feel free to do so anytime. 

Your input is always welcome! 
Thank you for taking the time to read the lengthy text.


![https://s3.memeshappen.com/memes/Thanks--meme-36035.png](https://velog.velcdn.com/images/catcota/post/5e96b328-0c53-4d79-a3f7-7b6ec2645de3/image.png)
<figcaption style="text-align:center; font-size:15px; color:#808080; margin-top:40px">
    Reference :  https://hasanozyer06.medium.com/selenium-driver-class-full-explanation-faf43e8ddfbe
  </figcaption>


#### Reference
https://velog.io/@ddophi98/클린-아키텍쳐

https://jerry311.tistory.com/73

https://jaime-note.tistory.com/406

https://medium.com/@apfhdznzl/data-layer-repository-datasource-9621d73b6144

https://blog.coderifleman.com/2017/12/18/the-clean-architecture/

https://gon125.github.io/posts/SwiftUI%EB%A5%BC-%EC%9C%84%ED%95%9C-%ED%81%B4%EB%A6%B0-%EC%95%84%ED%82%A4%ED%85%8D%EC%B2%98/

https://medium.com/@mooyoung2309/swiftui-mvvm-clean-architecture-%EC%8B%9C%EC%9E%91%ED%95%98%EA%B8%B0-1-b46dfc2e6213

https://github.com/Team-TravelGenie/TripChat

https://github.com/kudoleh/iOS-Clean-Architecture-MVVM

