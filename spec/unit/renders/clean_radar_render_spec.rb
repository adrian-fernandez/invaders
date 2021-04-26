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
        [true, true]
      ]
    )
  end

  let(:matches) do
    [
      { invader: invader, x: 1, y: 1, total_size: 2, matches_count: 2, accuracy: 1.0 }
    ]
  end

  subject(:call) do
    Invaders::Renders::CleanRadarRender.new(
      radar,
      matches,
      mapper: Invaders::Mappers::DefaultImageMapper,
      show_unmatches: show_unmatches
    ).call
  end

  context "without unmatches" do
    let(:show_unmatches) { false }

    it "returns rendered radar with found invaders" do
      expect(call).to eq(
        [
          "----\n-oo-\n-oo-\n----",
          "Invader x: 1, y: 1, accuracy: 100.0%"
        ]
      )
    end
  end

  context "with unmatches" do
    let(:show_unmatches) { true }

    it "returns rendered radar with found invaders" do
      expect(call).to eq(
        [
          "----\n-ox-\n-xo-\n----",
          "Invader x: 1, y: 1, accuracy: 100.0%"
        ]
      )
    end
  end
end
