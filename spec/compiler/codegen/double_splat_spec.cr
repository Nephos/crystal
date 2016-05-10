require "../../spec_helper"

describe "Codegen: double splat" do
  it "double splats named argument into arguments (1)" do
    run(%(
      def foo(x, y)
        x - y
      end

      tup = {x: 32, y: 10}
      foo **tup
      )).to_i.should eq(32 - 10)
  end

  it "double splats named argument into arguments (2)" do
    run(%(
      def foo(x, y)
        x - y
      end

      tup = {y: 10, x: 32}
      foo **tup
      )).to_i.should eq(32 - 10)
  end

  it "double splats named argument with positional arguments" do
    run(%(
      def foo(x, y, z)
        x - y*z
      end

      tup = {y: 20, z: 30}
      foo 1000, **tup
      )).to_i.should eq(1000 - 20*30)
  end

  it "double splats named argument with named args (1)" do
    run(%(
      def foo(x, y, z)
        x - y*z
      end

      tup = {x: 1000, z: 30}
      foo **tup, y: 20
      )).to_i.should eq(1000 - 20*30)
  end

  it "double splats named argument with named args (2)" do
    run(%(
      def foo(x, y, z)
        x - y*z
      end

      tup = {z: 30}
      foo **tup, x: 1000, y: 20
      )).to_i.should eq(1000 - 20*30)
  end

  it "double splats twice " do
    run(%(
      def foo(x, y, z, w)
        (x - y*z) * w
      end

      tup1 = {x: 1000, z: 30}
      tup2 = {y: 20, w: 40}
      foo **tup2, **tup1
      )).to_i.should eq((1000 - 20*30) * 40)
  end

  it "splats tuple that has named args inside" do
    run(%(
      def foo(x, y, z)
        x - y*z
      end

      tup = {1000, {z: 30, y: 20}}
      foo *tup
      )).to_i.should eq(1000 - 20*30)
  end

  it "single splat argument matches named args" do
    run(%(
      def foo(*args)
        arg = args[0]
        arg[:x] - arg[:y] * arg[:z]
      end

      foo x: 1000, z: 30, y: 20
      )).to_i.should eq(1000 - 20*30)
  end

  it "splats single splat twice, with default value and named args" do
    run(%(
      def foo(x, y = 3)
        x - y
      end

      foo(10)

      args = {10, {y: 8}}
      foo(*args)
      )).to_i.should eq(2)
  end

  it "single splat argument matches args and named args" do
    run(%(
      def foo(*args)
        (args[0] - args[1]*args[2][:z]) * args[2][:w]
      end

      foo 1000, 20, w: 40, z: 30
      )).to_i.should eq((1000 - 20*30) * 40)
  end

  it "matches double splat on method with named args" do
    run(%(
      def foo(**options)
        options[:x] - options[:y]
      end

      foo x: 10, y: 3
      )).to_i.should eq(7)
  end

  it "matches double splat on method with named args and regular args" do
    run(%(
      def foo(x, **args)
        x - args[:y]*args[:z]
      end

      foo y: 20, z: 30, x: 1000
      )).to_i.should eq(1000 - 20*30)
  end

  it "matches double splat with regular splat" do
    run(%(
      def foo(*args, **options)
        (args[0] - args[1]*options[:z]) * options[:w]
      end

      foo 1000, 20, z: 30, w: 40
      )).to_i.should eq((1000 - 20*30) * 40)
  end
end
