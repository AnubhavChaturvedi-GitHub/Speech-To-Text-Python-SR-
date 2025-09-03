# Animated SVG Example

Here’s a rotating square:

<img src="https://raw.githubusercontent.com/yourusername/yourrepo/main/animated.svg" width="150" />

<svg width="100" height="100" xmlns="http://www.w3.org/2000/svg">
  <rect x="25" y="25" width="50" height="50" fill="tomato">
    <animateTransform 
      attributeName="transform" 
      type="rotate"
      from="0 50 50"
      to="360 50 50"
      dur="3s"
      repeatCount="indefinite" />
  </rect>
</svg>
