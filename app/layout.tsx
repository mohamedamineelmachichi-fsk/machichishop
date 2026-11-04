import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = {title:'MACHICHI STORE | أناقتك تبدأ من هنا',description:'ملابس وصباط رجالي بستايل عصري، التوصيل للمغرب كامل والأداء عند الاستلام.',openGraph:{title:'MACHICHI STORE',description:'ذوقك يميزك، وأناقتك تبدأ من هنا!',type:'website'}};
export default function RootLayout({children}:{children:React.ReactNode}) {return <html lang="ar" dir="rtl"><body>{children}</body></html>}
