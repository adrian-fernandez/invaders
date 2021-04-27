require "spec_helper"

describe "#call" do
  context "with default mapper" do
    let(:raw_image) do
      <<~HEREDOC
        oo-o
        -oo-
        ----
        oooo
      HEREDOC
    end

    let(:subject) { Invaders::Services::ImageParser.new(raw_image).call }

    it "returns Array object of booleans" do
      expect(subject.class).to eq(Array)
      expect(subject.flatten.map(&:class).uniq).to eq([TrueClass, FalseClass])
    end

    it "image contains arrays of booleans" do
      expect(subject).to eq(
        [
          [true,  true,  false, true],
          [false, true,  true,  false],
          [false, false, false, false],
          [true,  true,  true,  true],
        ]
      )
    end
  end

  context "with custom mapper" do
    class SampleMapper
      OBJECT_CHAR = "1"
      UNMATCHED_OBJECT_CHAR = "x"
      BLANK_CHAR = "0"
      UNMATCHED_BLANK_CHAR = "_"
      LINEBREAK_CHAR = "\n"
    end

    let(:raw_image) do
      <<~HEREDOC
        1101
        0110
        0000
        1111
      HEREDOC
    end

    let(:subject) { Invaders::Services::ImageParser.new(raw_image, image_mapper: SampleMapper).call }

    it "returns Array object of booleans" do
      expect(subject.class).to eq(Array)
      expect(subject.flatten.map(&:class).uniq).to eq([TrueClass, FalseClass])
    end

    it "image contains arrays of booleans" do
      expect(subject).to eq(
        [
          [true,  true,  false, true],
          [false, true,  true,  false],
          [false, false, false, false],
          [true,  true,  true,  true],
        ]
      )
    end
  end
end
