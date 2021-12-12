require 'json'

丸数字文字列 = '⓪①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳㉑㉒㉓㉔㉕㉖㉗㉘㉙㉚㉛㉜㉝㉞㉟㊱㊲㊳㊴㊵㊶㊷㊸㊹㊺㊻㊼㊽㊾㊿'

丸数字配列 = 丸数字文字列.split(//)
丸数字パタン = Regexp.new('/' + 丸数字配列.join('|') + '/')

data = {}

authordata = {}

File.open('bit.csv'){ |f|
  f.each { |line|
    line.chomp!
    next unless line =~ /(19|20)/
    a = line.split(/,/)
    monname = a[0].sub(/bit /,'')
    unless data[monname]
      data[monname] = []
    end
    page = a[1]
    title = a[2]
    next if title == '表紙'
    next if title == '目次'
    next if title == 'アレフ・ゼロ'
    next if title == 'アレフ ・ゼロ'
    next if title == '単語帖'
    next if title == 'ぶっくす'
    next if title == '読者の広場'
    next if title == 'ドクタービット'
    next if title == 'bitレーダー'
    next if title == '原稿募集'
    next if title == '読者投稿規定，編集後記'
    next if title == 'コンピュータ・ニュース'

    b = title.split(/……/)
    authors = b[1]
    if authors
      authors_a = authors.split(/，/)
    end

    title = "[#{b[0]}]"
    if authors
      title += " "
      title += authors_a.map { |author|
        "[#{author}]"
        unless authordata[author]
          authordata[author] = []
        end
        authordata[author].push "[#{b[0]}] [#{monname}]"
      }.join(", ")
    end
    
    data[monname].push title
  }
}

sbdata = {}
sbdata['pages'] = []
data.each { |mon,lines|
  pagedata = {}
  pagedata['title'] = mon
  pagedata['lines'] = [mon]
  data[mon].each { |line|
    pagedata['lines'].push " #{line}"
  }
  sbdata['pages'].push pagedata
}
# puts sbdata.to_json

sbdata = {}
sbdata['pages'] = []
authordata.each { |author, d|
  pagedata = {}
  pagedata['title'] = author
  pagedata['lines'] = [author]
  authordata[author].each { |line|
    pagedata['lines'].push " #{line}"
  }
  sbdata['pages'].push pagedata
}
puts sbdata.to_json
