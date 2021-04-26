require "spec_helper"

describe "#call" do
  let(:radar) do
    ::Invaders::Models::Radar.new(
      [
        [true,  true,  false, true],
        [false, true,  false, false],
        [false, false, true,  true],
        [true,  true,  true,  true]
      ]
    )
  end

  let(:invader) do
    ::Invaders::Models::Invader.new(
      [
        [true, true],
        [true, true],
      ]
    )
  end

  subject(:call) { Invaders::Services::Scanner.new(radar: radar, invaders: [invader], tolerance: tolerance, min_invader_size: min_invader_size).call }

  context "with tolerance = 0.75 and min_invader_size = 1" do
    let(:tolerance) { 0.75 }
    let(:min_invader_size) { 1 }

    it "returns an array of hashes with results" do
      expect(call.class).to eq(Array)
      call.each do |result_element|
        expect(result_element.class).to eq(Hash)
      end
    end

    it "finds 3 possible invaders sorted by accuracy" do
      expect(call.size).to eq(3)

      expect(call[0]).to eq(
        {
          accuracy: 1.0,
          invader: invader,
          matches_count: 4,
          total_size: 4,
          x: 2,
          y: 2
        }
      )
      expect(call[1]).to eq(
        {
          accuracy: 0.75,
          invader: invader,
          matches_count: 3,
          total_size: 4,
          x: 0,
          y: 0
        }
      )

      expect(call[2]).to eq(
        {
          accuracy: 0.75,
          invader: invader,
          matches_count: 3,
          total_size: 4,
          x: 1,
          y: 2
        }
      )
    end
  end

  context "with tolerance = 0.751 and min_invader_size = 1" do
    let(:tolerance) { 0.751 }
    let(:min_invader_size) { 1 }

    it "returns an array of hashes with results" do
      expect(call.class).to eq(Array)
      call.each do |result_element|
        expect(result_element.class).to eq(Hash)
      end
    end

    it "finds 1 possible invaders sorted by accuracy" do
      expect(call.size).to eq(1)

      expect(call[0]).to eq(
        {
          accuracy: 1.0,
          invader: invader,
          matches_count: 4,
          total_size: 4,
          x: 2,
          y: 2
        }
      )
    end
  end

  context "with tolerance = 1 and min_invader_size = 0.5" do
    let(:tolerance) { 1 }
    let(:min_invader_size) { 0.5 }

    it "returns an array of hashes with results" do
      expect(call.class).to eq(Array)
      call.each do |result_element|
        expect(result_element.class).to eq(Hash)
      end
    end

    it "finds 4 possible invaders sorted by accuracy" do
      expect(call.size).to eq(4)

      expect(call[0]).to eq(
        {
          accuracy: 1.0,
          invader: invader,
          matches_count: 4,
          total_size: 4,
          x: 2,
          y: 2
        }
      )

      expect(call[1]).to eq(
        {
          accuracy: 1.0,
          invader: invader,
          matches_count: 2,
          total_size: 2,
          x: 3,
          y: 2
        }
      )

      expect(call[2]).to eq(
        {
          accuracy: 1.0,
          invader: invader,
          matches_count: 2,
          total_size: 2,
          x: 1,
          y: 3
        }
      )

      expect(call[3]).to eq(
        {
          accuracy: 1.0,
          invader: invader,
          matches_count: 2,
          total_size: 2,
          x: 2,
          y: 3
        }
      )
    end
  end
end
