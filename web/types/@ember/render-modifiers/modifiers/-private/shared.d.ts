import Modifier from 'ember-modifier';

interface RenderModifierSignature<
  Element extends HTMLElement | SVGElement,
  Args extends unknown[]
> {
  Args: { Positional: [(element: Element, args: Args) => unknown, ...Args] };
  Element: Element;
}

// TODO: Can we avoid setting the default?
export declare class RenderModifier<
  Element extends HTMLElement | SVGElement,
  Args extends unknown[]
> extends Modifier<RenderModifierSignature<Element, Args>> {}
