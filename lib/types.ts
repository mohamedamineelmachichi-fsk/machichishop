export type Variant = { id?: string; color: string; size: string; stock: number };
export type Product = { id: string; name: string; description: string; category: string; kind: 'shoes'|'clothing'; price: number; old_price: number|null; images: string[]; color_images: Record<string,string[]>; variants: Variant[]; featured: boolean; is_new: boolean; published: boolean; created_at?: string };
export type CartItem = { key: string; product: Product; color: string; size: string; qty: number };
