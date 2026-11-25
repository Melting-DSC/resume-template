// 中間発表 予稿テンプレート
//
// 使い方:
//   #import "template.typ": conf, references
//   #show: conf.with(
//       title: [表題],
//       author: "氏名",
//       student-id: "学籍番号",
//       abstract: [概要],
//       keywords: ("キーワード1", "キーワード2"),
//   )

#let conf(
    title: none,
    author: none,
    student-id: none,
    abstract: none,
    keywords: (),
    body,
) = {
    // ドキュメントプロパティ (PDFメタデータ)
    set document(
        title: title,
        author: if author == none { () } else if type(author) == array { author } else { (author,) },
        keywords: if type(keywords) == array { keywords } else { () },
    )

    // ページ基本設定
    set text(
        font: "Yu Mincho",
        size: 9pt,
        lang: "ja",
    )

    set page(
        paper: "a4",
        // ヘッダー: 1ページ目のみ「氏名 (学籍番号)」を表示
        header: context {
            if counter(page).get().first() == 1 {
                if author != none [#author]
                if student-id != none [ (#student-id)]
            }
        },
        margin: (top: 20mm, bottom: 20mm, x: 12.7mm),
        columns: 2,
    )

    set par(justify: true, leading: .74em, spacing: 0.9em, first-line-indent: (all: true, amount: 1em))

    // 句読点をカンマ・ピリオド(全角)に矯正
    show "、": it => [，]
    show "。": it => [．]

    // 見出し設定
    set heading(numbering: "1.")
    show heading: set text(9pt)

    // リストの書式設定
    show list: set par(spacing: 1.5em)

    // 図表の書式設定
    show figure.where(kind: table): set figure.caption(position: top)
    show figure: set par(spacing: 1.5em)
    set table(stroke: none)

    // 表題と概要
    place(
        top + center,
        float: true,
        scope: "parent",
        clearance: 2em,
    )[
        // 表題
        #align(center,
            block(
                stroke: (top: 1pt + black, bottom: 1pt + black),
                width: 100%,
                inset: (y: .7em),
                text(size: 11pt, strong(title)),
            )
        )
        // 概要・キーワード
        #align(left, par(first-line-indent: 0em)[
            #if abstract != none [
                *概要　*#abstract
            ]
            #if keywords != none and keywords != () [
                \
                *キーワード：*#{
                    if type(keywords) == array { keywords.join("、") } else { keywords }
                }
            ]
        ])
    ]

    body
}

// 参考文献セクション
// 使い方:
//   #references[
//       + 著者：書名，出版社（年）．
//   ]
#let references(body) = {
    heading(numbering: none)[参考文献]
    set enum(numbering: "[1]")
    show link: set text(fill: blue)
    body
}
