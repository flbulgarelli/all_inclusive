module AllInclusive
  def self.inflectable?(word, ending)
    word.downcase.end_with?(ending)
  end

  def self.inflect(word, ending, replacement)
    word
      .gsub(/(.*)#{ending}$/) { "#{$1}#{replacement}" }
      .gsub(/(.*)#{ending.upcase}$/) { "#{$1}#{replacement.upcase}" }
  end

  def self.inclusivize(word)
    case word
    # special articles
    when "el" then "le"
    when "EL" then "LE"
    # special pronouns
    when "un" then "une"
    else
      # special adjectives
      if inflectable? word, 'or'
        inflect word, 'or', 'er'
      elsif inflectable? word, 'ora'
        inflect word, 'ora', 'er'
      # generic c nouns, pronuns and adjectives
      elsif inflectable? word, 'co'
        inflect word, 'co', 'que'
      elsif inflectable? word, 'ca'
        inflect word, 'ca', 'que'
      elsif inflectable? word, 'cos'
        inflect word, 'cos', 'ques'
      elsif inflectable? word, 'cas'
        inflect word, 'cas', 'ques'
      # generic q nouns, pronuns and adjectives
      elsif inflectable? word, 'go'
        inflect word, 'go', 'gue'
      elsif inflectable? word, 'ga'
        inflect word, 'ga', 'gue'
      elsif inflectable? word, 'gas'
        inflect word, 'gas', 'gues'
      elsif inflectable? word, 'gos'
        inflect word, 'gos', 'gues'
      # generic nouns, pronouns and adjectives
      elsif inflectable? word, 'o'
        inflect(word, 'o', 'e')
      elsif inflectable? word, 'a'
        inflect(word, 'a', 'e')
      elsif inflectable? word, 'os'
        inflect(word, 'os', 'es')
      elsif inflectable? word, 'as'
        inflect(word, 'as', 'es')
      else
        word
      end
    end
  end
end

describe "inflections" do
  def expect_inclusive(original, inclusive)
    expect(AllInclusive.inclusivize(original)).to eq inclusive
  end

  describe 'nouns' do
    # neutral nouns
    it { expect_inclusive("docente", "docente") }

    # masculine nouns
    it { expect_inclusive("alumno", "alumne") }
    it { expect_inclusive("enfermero", "enfermere") }

    # femenine nouns
    it { expect_inclusive("enfermera", "enfermere") }
    it { expect_inclusive("maestra", "maestre") }

    # caps handling
    it { expect_inclusive("ALUMNO", "ALUMNE") }
    it { expect_inclusive("ALUMNA", "ALUMNE") }

    # masculine plurals
    it { expect_inclusive("maestros", "maestres") }

    # femenine plurals
    it { expect_inclusive("maestras", "maestres") }

    # caps handling
    it { expect_inclusive("MAESTROS", "MAESTRES") }
    it { expect_inclusive("MAESTRAS", "MAESTRES") }

    # special C nouns
    it { expect_inclusive("chico", "chique") }
    it { expect_inclusive("chica", "chique") }
    it { expect_inclusive("chicas", "chiques") }
    it { expect_inclusive("chicos", "chiques") }

    # special G nouns
    it { expect_inclusive("amigo", "amigue") }
    it { expect_inclusive("amiga", "amigue") }
    it { expect_inclusive("amigas", "amigues") }
    it { expect_inclusive("amigos", "amigues") }

    pending { expect(AllInclusive.inclusivize "amigos", AllInclusive::XStyle).to eq 'amigxs' }
    pending { expect(AllInclusive.inclusivize "amigos", AllInclusive::AtStyle).to eq 'amig@s' }
  end

  describe 'articles' do
    it { expect_inclusive('el', 'le') }
    it { expect_inclusive('la', 'le') }
    it { expect_inclusive('los', 'les') }
    it { expect_inclusive('las', 'les') }

    # caps handling
    it { expect_inclusive('LAS', 'LES') }
    it { expect_inclusive('LOS', 'LES') }
    it { expect_inclusive('EL', 'LE') }
    it { expect_inclusive('LA', 'LE') }
  end

  describe 'adjectives' do
    it { expect_inclusive("comprador", "comprader") }
    it { expect_inclusive("pensador", "pensader") }
    it { expect_inclusive("vendedor", "vendeder") }

    it { expect_inclusive("compradora", "comprader") }
    it { expect_inclusive("pensadora", "pensader") }

    # TODO is this right?
    pending { expect_inclusive("tieso", 'tiece') }
    pending { expect_inclusive("amistosa", 'amistoce') }
  end

  describe 'pronoun' do
    it { expect_inclusive('un', 'une') }
    it { expect_inclusive('uno', 'une') }
    it { expect_inclusive('una', 'une') }
    it { expect_inclusive('muchos', 'muches') }
    it { expect_inclusive('todas', 'todes') }
  end

end


# TODO
# ====
#
# handle more complex scenarios
# handle article-noun combinations
# handle x and @ conventions
# handle "las y los", "los y las", "el y la", etc
# handle adjectives
# handle article - adjective - noun combinations
# allow to convert into forms
# allow to detect non-inclusive language usage - that is trickier!
# refactor
