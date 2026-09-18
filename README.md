# Vyapar AI - GitHub Ready

### Vercel pe Deploy kaise kare (Mobile se bhi)

1. GitHub pe New Repo `vyapar-ai` banao -> is zip ke files upload karo
2. vercel.com -> Add New Project -> Import Git Repository `vyapar-ai`
3. Import karte hi Environment Variables ka box ayega:
   - NEXT_PUBLIC_SUPABASE_URL = https://xxxx.supabase.co
   - NEXT_PUBLIC_SUPABASE_ANON_KEY = eyJ...
4. Deploy -> Ready

Agar Vercel Drop wala project ka Settings page error de raha hai, to ye GitHub wala method 100% kaam karega.

### Supabase Setup
- supabase.com -> New Project (Mumbai)
- SQL Editor -> supabase/schema.sql run karo (ye repo me hai)
- Settings -> API se URL aur anon key copy karo

### Security
- anon key public hai, RLS se protected hai
- service_role key kabhi bhi frontend me mat daalo, kabhi share mat karo

App khulne ke baad Settings me UPI ID, GSTIN, Business Name bhar do.
