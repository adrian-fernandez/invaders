require "spec_helper"

describe "validations" do
  subject(:action) { ::Invaders::Models::Image.new(raw_image_data) }

  context "when raw data is not an array" do
    let(:raw_image_data) { "" }

    it "raises an error" do
      expect { action }.to raise_error(Invaders::ImageError, "Image data must be an array")
    end
  end

  context "when arrays in raw data don't have the same size" do
    let(:raw_image_data) { [[true], [true, true]] }

    it "raises an error" do
      expect { action }.to raise_error(Invaders::ImageError, "All rows in the image data must have the same size(1, 2)")
    end
  end

  context "when raw data is valid" do
    let(:raw_image_data) { [[true, false], [true, true]] }

    it "raises an error" do
      expect { action }.not_to raise_error
    end
  end
end

describe "#each_with_index" do
  let(:image) { ::Invaders::Models::Image.new([["A", "B"], ["C", "D"]]) }

  it "iterates over the image data" do
    a = []
    image.each_with_index do |element, index|
      a << [element, index]
    end

    expect(a).to eq([
      [["A", "B"], 0],
      [["C", "D"], 1]
    ])
  end
end

describe "#subimage" do
  let(:image) { ::Invaders::Models::Image.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]]) }
  subject(:subimage) { image.subimage(x, y, width, height) }

  context "when data is correct and have only 1 pixel" do
    let(:x) { 1 }
    let(:y) { 1 }
    let(:width) { 1 }
    let(:height) { 1 }

    it "returns partial image" do
      expect(subimage.image).to eq([[5]])
    end
  end

  context "when data is correct and have more than 1 pixel" do
    let(:x) { 1 }
    let(:y) { 0 }
    let(:width) { 2 }
    let(:height) { 3 }

    it "returns partial image" do
      expect(subimage.image).to eq(
        [
          [2, 3],
          [5, 6],
          [8, 9]
        ]
      )
    end
  end

  context "when data is correct and have subimage is the full image" do
    let(:x) { 0 }
    let(:y) { 0 }
    let(:width) { 3 }
    let(:height) { 3 }

    it "returns partial image" do
      expect(subimage.image).to eq(
        [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9]
        ]
      )
    end
  end

  context "when coordinates are invalid" do
    let(:x) { 0 }
    let(:y) { 0 }
    let(:width) { 1 }
    let(:height) { 1 }

    context "when x is negative" do
      let(:x) { -1 }

      it "raises an exception" do
        expect { subimage }.to raise_error(Invaders::ImageError, "Selected coordinates for the subimage are not valid")
      end
    end

    context "when y is negative" do
      let(:y) { -1 }

      it "raises an exception" do
        expect { subimage }.to raise_error(Invaders::ImageError, "Selected coordinates for the subimage are not valid")
      end
    end

    context "when x + width is bigger than image" do
      let(:x) { 1 }
      let(:width) { 3 }

      it "raises an exception" do
        expect { subimage }.to raise_error(Invaders::ImageError, "Selected coordinates for the subimage are not valid")
      end
    end

    context "when y + height is bigger than image" do
      let(:y) { 1 }
      let(:height) { 3 }

      it "raises an exception" do
        expect { subimage }.to raise_error(Invaders::ImageError, "Selected coordinates for the subimage are not valid")
      end
    end
  end
end

describe "#value_at" do
  let(:image) { ::Invaders::Models::Image.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]]) }
  subject { image.value_at(2, 1) }

  it { is_expected.to eq(8) }
end

describe "#to_s" do
  let(:image) { ::Invaders::Models::Image.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]]) }
  subject { image.to_s }

  it { is_expected.to eq("[[1, 2, 3], [4, 5, 6], [7, 8, 9]]") }
end

describe "#to_s" do
  let(:image) { ::Invaders::Models::Image.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]]) }
  subject { image.to_s }

  it { is_expected.to eq("[[1, 2, 3], [4, 5, 6], [7, 8, 9]]") }
end

describe "#width" do
  let(:image) { ::Invaders::Models::Image.new([[1, 2, 3], [4, 5, 6]]) }
  subject { image.width }

  it { is_expected.to eq(3) }
end

describe "#height" do
  let(:image) { ::Invaders::Models::Image.new([[1, 2, 3], [4, 5, 6]]) }
  subject { image.height }

  it { is_expected.to eq(2) }
end

describe "#linear_image" do
  let(:image) { ::Invaders::Models::Image.new([[1, 2, 3], [4, 5, 6]]) }
  subject { image.linear_image }

  it { is_expected.to eq([1, 2, 3, 4, 5, 6]) }
end

describe "#compare" do
  let(:image) { ::Invaders::Models::Image.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]]) }
  subject(:compare) { image.compare(other_image) }

  context "when other image has different size" do
    let(:other_image) { ::Invaders::Models::Image.new([[1, 2, 3], [4, 5, 6]]) }

    it "raises an exception" do
      expect { compare }.to raise_error(Invaders::ImageError)
    end
  end

  context "when other image has the same size" do
    context "when there is a partial match" do
      let(:other_image) { ::Invaders::Models::Image.new([[1, 2, 0], [0, 5, 6], [7, 0, 9]]) }

      it "returns hash with results" do
        expect(compare).to eq({
          matches_count: 6,
          total_size: 9,
          accuracy: 6 / 9.0
        })
      end
    end

    context "when there is a total match" do
      let(:other_image) { ::Invaders::Models::Image.new([[1, 2, 3], [4, 5, 6], [7, 8, 9]]) }

      it "returns hash with results" do
        expect(compare).to eq({
          matches_count: 9,
          total_size: 9,
          accuracy: 1.0
        })
      end
    end

    context "when there is no match" do
      let(:other_image) { ::Invaders::Models::Image.new([[0, 0, 0], [0, 0, 0], [0, 0, 0]]) }

      it "returns hash with results" do
        expect(compare).to eq({
          matches_count: 0,
          total_size: 9,
          accuracy: 0.0
        })
      end
    end
  end
end

