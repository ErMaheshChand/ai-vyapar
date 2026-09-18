# Vyapar AI - Final Full Project

Ye final wala pura project hai: Dashboard + Customers (Khatabook) + Stock + GST Bill + Sales

## Deploy
1. GitHub repo ai-vyapar me is zip ke files se replace karo (Upload)
2. Vercel auto-deploy karega
3. Supabase me supabase/schema.sql run karo (balance_due, invoice_no fix included)
4. Site kholke Setup me Supabase URL + anon key daalo

## Modules
- Customers: balance_due, total_sale, phone
- Products: cost_price, selling_price, stock, gst_rate, hsn_code
- Sales: invoice_no, subtotal, gst_total, cgst, sgst, items jsonb
- Payments: UTR, UPI app, verified
- Business Settings: localStorage me
