require "spec_helper"

describe "#subinvader" do
  let(:radar) do
    ::Invaders::Models::Radar.new(
      [
        [1,   2,  3,  4, 5],
        [6,   7,  8,  9, 10],
        [11, 12, 13, 14, 15],
        [16, 17, 18, 19, 20],
        [21, 22, 23, 24, 25],
      ]
    )
  end

  let(:invader) do
    ::Invaders::Models::Invader.new(
      [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
      ]
    )
  end

  subject(:call) { invader.subinvader(radar, x, y) }

  context "subinvader bigger than original invader" do
    let(:x) { 2 }
    let(:y) { 2 }

    it "returns the same invader as original" do
      expect(call).to eq(invader)
    end
  end

  context "subinvader cropped by the left" do
    let(:x) { 1 }
    let(:y) { 2 }

    it "returns the same invader as original" do
      new_invader = call
      expect(new_invader.width).to eq(2)
      expect(new_invader.height).to eq(3)
      expect(new_invader.image).to eq(
        [
          [2, 3],
          [5, 6],
          [8, 9]
        ]
      )
    end
  end

  context "subinvader cropped by the top" do
    let(:x) { 2 }
    let(:y) { 1 }

    it "returns the same invader as original" do
      new_invader = call
      expect(new_invader.width).to eq(3)
      expect(new_invader.height).to eq(2)
      expect(new_invader.image).to eq(
        [
          [4, 5, 6],
          [7, 8, 9]
        ]
      )
    end
  end

  context "subinvader cropped by the top and left" do
    let(:x) { 1 }
    let(:y) { 1 }

    it "returns the same invader as original" do
      new_invader = call
      expect(new_invader.width).to eq(2)
      expect(new_invader.height).to eq(2)
      expect(new_invader.image).to eq(
        [
          [5, 6],
          [8, 9]
        ]
      )
    end
  end

  context "subinvader cropped by the right" do
    let(:x) { 3 }
    let(:y) { 2 }

    it "returns the same invader as original" do
      new_invader = call
      expect(new_invader.width).to eq(2)
      expect(new_invader.height).to eq(3)
      expect(new_invader.image).to eq(
        [
          [1, 2],
          [4, 5],
          [7, 8]
        ]
      )
    end
  end

  context "subinvader cropped by the top and right" do
    let(:x) { 3 }
    let(:y) { 1 }

    it "returns the same invader as original" do
      new_invader = call
      expect(new_invader.width).to eq(2)
      expect(new_invader.height).to eq(2)
      expect(new_invader.image).to eq(
        [
          [4, 5],
          [7, 8]
        ]
      )
    end
  end

  context "subinvader cropped by the bottom" do
    let(:x) { 2 }
    let(:y) { 3 }

    it "returns the same invader as original" do
      new_invader = call
      expect(new_invader.width).to eq(3)
      expect(new_invader.height).to eq(2)
      expect(new_invader.image).to eq(
        [
          [1, 2, 3],
          [4, 5, 6]
        ]
      )
    end
  end

  context "subinvader cropped by the bottom and right" do
    let(:x) { 3 }
    let(:y) { 3 }

    it "returns the same invader as original" do
      new_invader = call
      expect(new_invader.width).to eq(2)
      expect(new_invader.height).to eq(2)
      expect(new_invader.image).to eq(
        [
          [1, 2],
          [4, 5]
        ]
      )
    end
  end

  context "subinvader cropped by the bottom and left" do
    let(:x) { 1 }
    let(:y) { 3 }

    it "returns the same invader as original" do
      new_invader = call
      expect(new_invader.width).to eq(2)
      expect(new_invader.height).to eq(2)
      expect(new_invader.image).to eq(
        [
          [2, 3],
          [5, 6]
        ]
      )
    end
  end
end

