import type {Product} from './types';
// Visual examples only; no invented inventory. Stock is zero until owner sets real quantities.
export const demoProducts:Product[]=[
 {id:'demo-jeans',name:'BAGGY JEAN DARK BLUE',description:'جينز باغي أزرق غامق بستايل عصري. الصور للعرض فقط، خاص تأكيد المخزون قبل النشر.',category:'جينز',kind:'clothing',price:289,old_price:390,images:['/products/jeans.webp'],color_images:{'أزرق غامق':['/products/jeans.webp']},variants:[31,32,33,34,36].map(size=>({color:'أزرق غامق',size:String(size),stock:0})),featured:true,is_new:false,published:true},
 {id:'demo-zipper',name:'ENSEMBLE ZIPPER OVERSIZE',description:'طقم أوفرسايز بسحاب. الصور للعرض فقط، خاص تأكيد المخزون قبل النشر.',category:'أطقم',kind:'clothing',price:229,old_price:null,images:['/products/zipper.webp'],color_images:{'رمادي':['/products/zipper.webp']},variants:['M','L','XL'].map(size=>({color:'رمادي',size,stock:0})),featured:true,is_new:true,published:true}
];
